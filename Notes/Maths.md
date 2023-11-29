Document considering the maths of the problem

The bible has the 3 equations, corresponding to eqs.66-68:

1.1) $$ -u \sqrt{1+\gamma^2|\psi|^2}\left(\frac{\partial}{\partial t}+i \varphi\right) \psi+\nabla^2 \psi+i \gamma^2 \psi \nabla^2 \varphi+\left(1-|\psi|^2\right) \psi=0 $$

1.2) $$\nabla^2 \varphi=\frac{\bar{\psi} \nabla^2 \psi-\psi \nabla^2 \bar{\psi}}{2 i}$$

1.3) $$\underline{j}=\frac{\bar{\psi} \nabla \psi-\psi \nabla \bar{\psi}}{2 i}-\nabla \varphi$$



***Considering Complex $\psi$***

$\psi$ is complex, and thus for the solving of the problem using FE, it must be separated into real and imaginary parts, so that $\psi = \psi_R + i\psi_I$.  

Considering *Eq 1.1* first:

1.1.1) $$0 = -u \sqrt{1+\gamma^2*(\psi_R^2 + \psi_I^2)}\left(\frac{\partial}{\partial t}+i \varphi\right) (\psi_R + i\psi_I)+\nabla^2 (\psi_R + i\psi_I)+i \gamma^2 (\psi_R + i\psi_I) \nabla^2 \varphi+\left(1-\psi_R^2 - \psi_I^2\right) \psi $$

Then separating this into Real and Imaginary parts we get: 

 1.1.2) $$0=-u \sqrt{1+\gamma^2\left(\psi_R^2+\psi_I^2\right)}\left(\frac{\partial}{\partial t} \psi_R-\varphi \psi_I\right)+\nabla^2 \psi_R-\gamma^2 \psi_I \nabla^2 \varphi+\left(1-\psi_R^2-\psi_I^2\right) \psi_R$$


 1.1.3) $$0=-u \sqrt{1+\gamma^2\left(\psi_R^2+\psi_I^2\right)}\left(\frac{\partial}{\partial t} \psi_I+\varphi \psi_R\right)+\nabla^2 \psi_I+\gamma^2 \psi_R \nabla^2 \varphi+\left(1-\psi_R^2-\psi_I^2\right) \psi_I$$


Considering *Eq 1.2*:

1.2.1) $$\nabla^2 \varphi=\frac{(\psi_R - i\psi_I) \nabla^2 (\psi_R + i\psi_I)-(\psi_R + i\psi_I) \nabla^2 (\psi_R - i\psi_I)}{2 i}$$

1.2.2) $$\nabla^2 \varphi=\frac{(\psi_R \nabla^2\psi_R - i \psi_I \nabla^2 \psi_R + i \psi_R \nabla^2\psi_I + \psi_I \nabla^2\psi_I)-(\psi_R \nabla^2\psi_R + i \psi_I \nabla^2 \psi_R - i \psi_R \nabla^2\psi_I + \psi_I \nabla^2\psi_I)}{2 i}$$

1.2.3) $$\nabla^2 \varphi=\psi_R \nabla^2 \psi_I -\psi_I \nabla^2 \psi_R$$

1.2.4) $$0=\nabla^2 \varphi-\psi_R \nabla^2 \psi_I+\psi_I \nabla^2 \psi_R$$

Considering *Eq 1.3*:

1.3.1) $$\underline{j}=\frac{(\psi_R - i\psi_I) \nabla (\psi_R + i\psi_I)-(\psi_R + i\psi_I) \nabla (\psi_R - i\psi_I)}{2 i}-\nabla \varphi$$

1.3.2) $$\underline{j}=\frac{(\psi_R \nabla\psi_R - i \psi_I \nabla \psi_R + i \psi_R \nabla \psi_I + \psi_I \nabla \psi_I)-(\psi_R \nabla \psi_R + i \psi_I \nabla \psi_R - i \psi_R \nabla \psi_I + \psi_I \nabla \psi_I)}{2 i}-\nabla \varphi$$

1.3.3) $$\underline{j}=\psi_R \nabla \psi_I- \psi_I \nabla \psi_R -\nabla \varphi$$

1.3.4) $$0=\underline{j}+\nabla \varphi-\psi_R \nabla \psi_I+\psi_I \nabla \psi_R$$



**Final split Eqs.**

We now have a set of equations for variables $\psi_R$, $\psi_I$, $\Phi$, and $\underline{j}$ that are ready to be converted into the weak form:

2.1) $$0=-u \sqrt{1+\gamma^2\left(\psi_R^2+\psi_I^2\right)}\left(\frac{\partial}{\partial t} \psi_R-\varphi \psi_I\right)+\nabla^2 \psi_R-\gamma^2 \psi_I \nabla^2 \varphi+\left(1-\psi_R^2-\psi_I^2\right) \psi_R$$


2.2) $$0=-u \sqrt{1+\gamma^2\left(\psi_R^2+\psi_I^2\right)}\left(\frac{\partial}{\partial t} \psi_I+\varphi \psi_R\right)+\nabla^2 \psi_I+\gamma^2 \psi_R \nabla^2 \varphi+\left(1-\psi_R^2-\psi_I^2\right) \psi_I$$

2.3) $$0=\nabla^2 \varphi-\psi_R \nabla^2 \psi_I+\psi_I \nabla^2 \psi_R$$

2.4) $$0=\underline{j}+\nabla \varphi-\psi_R \nabla \psi_I+\psi_I \nabla \psi_R$$


***Now to make these kernels!***

We will use the method of weighted residuals, with test function $\mu$.

Taking *Eq 2.1*,

2.1.1) $$\mu \Biggl(-u \sqrt{1+\gamma^2\left(\psi_R^2+\psi_I^2\right)}\left(\frac{\partial}{\partial t} \psi_R-\varphi \psi_I\right)+\nabla^2 \psi_R-\gamma^2 \psi_I \nabla^2 \varphi+\left(1-\psi_R^2-\psi_I^2\right) \psi_R \Biggl) = 0, \forall \mu$$

2.1.2) $$\int_{\Omega}\mu \Biggl(-u \sqrt{1+\gamma^2\left(\psi_R^2+\psi_I^2\right)}\left(\frac{\partial}{\partial t} \psi_R-\varphi \psi_I\right)+\nabla^2 \psi_R-\gamma^2 \psi_I \nabla^2 \varphi+\left(1-\psi_R^2-\psi_I^2\right) \psi_R \Biggl) = 0$$

2.1.3) $$\int_{\Omega}\mu \Bigl(-u \sqrt{1+\gamma^2\left(\psi_R^2+\psi_I^2\right)}\left(\frac{\partial}{\partial t} \psi_R-\varphi \psi_I\right)\Bigl) + \int_{\Omega}\mu\Bigl(\nabla^2 \psi_R\Bigl)-\int_{\Omega}\mu\Bigl(\gamma^2 \psi_I \nabla^2 \varphi\Bigl)+\int_{\Omega}\mu\Bigl((1-\psi_R^2-\psi_I^2) \psi_R\Bigl) = 0$$

I will separate these four integrals and consider them individually:

3.1.1)$$\int_{\Omega}\mu \Bigl(-u \sqrt{1+\gamma^2\left(\psi_R^2+\psi_I^2\right)}\left(\frac{\partial}{\partial t} \psi_R-\varphi \psi_I\right)\Bigl)$$

3.1.2)$$ \int_{\Omega}\mu\Bigl(\nabla^2 \psi_R\Bigl)$$

3.1.3)$$-\int_{\Omega}\mu\Bigl(\gamma^2 \psi_I \nabla^2 \varphi\Bigl)$$

3.1.4) $$\int_{\Omega}\mu\Bigl((1-\psi_R^2-\psi_I^2) \psi_R\Bigl)$$

Note here that the order only need to be reduced for *Eq 3.1.2 and 3.1.3* 

Applying the product rule to *3.1.2*:

3.1.2.1) $$ \mu(\nabla^2 \psi_R) = \nabla \cdot(\mu \nabla \psi_R) - \nabla \mu\cdot \nabla \psi_R$$

Applying the product rule to *3.1.3*:

3.1.3.1)
$$ \mu(-\gamma^2 \psi_I \nabla^2 \varphi) = -\nabla \cdot(\mu \gamma^2 \psi_I \nabla \varphi)+ \gamma^2 \psi_I \nabla \varphi\nabla\mu + \gamma^2 \mu \nabla \varphi\nabla\psi_I   $$

Performing the integral on *Eq 3.1.2*

3.1.2.2) $$\int_{\Omega}\nabla \cdot(\mu \nabla \psi_R) + \int_{\Omega}- \nabla \mu\cdot \nabla \psi_R$$

By applying the divergence theorem we get,

3.1.2.3) $$\oint_{\Gamma}(\mu \nabla \psi_R) \cdot \hat{n} + \int_{\Omega}- \nabla \mu\cdot \nabla \psi_R$$

Similarly for *Eq 3.1.3*

3.1.3.2) $$\int_{\Omega} -\nabla \cdot(\mu \gamma^2 \psi_I \nabla \varphi) + \int_{\Omega}\gamma^2 \psi_I \nabla \varphi\nabla\mu + \int_{\Omega}\gamma^2 \mu \nabla \varphi\nabla\psi_I$$

Similarly applying the divergance theorem we get,

3.1.3.3) $$-\oint_{\Gamma} (\mu \gamma^2 \psi_I \nabla \varphi) \cdot \hat{n} + \int_{\Omega}\gamma^2 \psi_I \nabla \varphi\nabla\mu + \int_{\Omega}\gamma^2 \mu \nabla \varphi\nabla\psi_I$$

Combining these recombining these equations for *3.1* in kernel form,

4.1) $$0=\Biggl( \mu , \Bigl(-u \sqrt{1+\gamma^2\left(\psi_R^2+\psi_I^2\right)}\left(\frac{\partial}{\partial t} \psi_R-\varphi \psi_I\right)\Bigl)\Biggl) \\ + \Biggl \lang \mu , \nabla \psi_R  \Biggl\rang  + \Biggl(\nabla \mu, - \nabla \psi_R \Biggl) \\- \Biggl\lang \mu,  \gamma^2 \psi_I \nabla \varphi \cdot \hat{n}  \Biggl\rang +\Biggl(\nabla \mu ,\gamma^2 \psi_I \nabla \varphi \Biggl)  + \Biggl(\mu, \gamma^2 \nabla \varphi\nabla\psi_I \Biggl) \\ +\Biggl( \mu, (1-\psi_R^2-\psi_I^2) \psi_R \Biggl)$$


*Repeating the process for Eq 2.2*

2.2.1) $$\mu \Biggl(-u \sqrt{1+\gamma^2\left(\psi_R^2+\psi_I^2\right)}\left(\frac{\partial}{\partial t} \psi_I+\varphi \psi_R\right)+\nabla^2 \psi_I+\gamma^2 \psi_R \nabla^2 \varphi+\left(1-\psi_R^2-\psi_I^2\right) \psi_I \Biggl) = 0, \forall \mu$$

2.2.2) $$\int_{\Omega}\mu \Biggl(-u \sqrt{1+\gamma^2\left(\psi_R^2+\psi_I^2\right)}\left(\frac{\partial}{\partial t} \psi_I+\varphi \psi_R\right)+\nabla^2 \psi_I+\gamma^2 \psi_R \nabla^2 \varphi+\left(1-\psi_R^2-\psi_I^2\right) \psi_I \Biggl) = 0$$

2.2.3) $$\int_{\Omega}\mu \Bigl(-u \sqrt{1+\gamma^2\left(\psi_R^2+\psi_I^2\right)}\left(\frac{\partial}{\partial t} \psi_I+\varphi \psi_R\right)\Bigl) + \int_{\Omega}\mu\Bigl(\nabla^2 \psi_I\Bigl)+\int_{\Omega}\mu\Bigl(\gamma^2 \psi_R \nabla^2 \varphi\Bigl)+\int_{\Omega}\mu\Bigl((1-\psi_R^2-\psi_I^2) \psi_I\Bigl) = 0$$

Separating these we get,

3.2.1) $$\int_{\Omega}\mu \Bigl(-u \sqrt{1+\gamma^2\left(\psi_R^2+\psi_I^2\right)}\left(\frac{\partial}{\partial t} \psi_I+\varphi \psi_R\right)\Bigl)$$

3.2.2) $$\int_{\Omega}\mu\Bigl(\nabla^2 \psi_I\Bigl)$$

3.2.3) $$\int_{\Omega}\mu\Bigl(\gamma^2 \psi_R \nabla^2 \varphi\Bigl)$$

3.2.4) $$\int_{\Omega}\mu\Bigl((1-\psi_R^2-\psi_I^2) \psi_I\Bigl)$$

Note here that the order only need to be reduced for *Eq 3.2.2 and 3.2.3* 

Applying the product rule to *3.2.2*:

3.2.2.1) $$ \mu(\nabla^2 \psi_I) = \nabla \cdot(\mu \nabla \psi_I) - \nabla \mu\cdot \nabla \psi_I$$

Applying the product rule *3.2.3*:

3.2.3.1) $$ \mu(\gamma^2 \psi_R \nabla^2 \varphi) = \nabla \cdot(\mu \gamma^2 \psi_R \nabla \varphi)- \gamma^2 \psi_R \nabla \varphi\cdot\nabla\mu - \gamma^2 \mu \nabla \varphi\cdot\nabla\psi_R   $$


Performing the integral on *Eq 3.2.2*

3.2.2.2) $$\int_{\Omega}\nabla \cdot(\mu \nabla \psi_I) + \int_{\Omega}- \nabla \mu\cdot \nabla \psi_I$$

By applying the divergence theorem we get,

3.2.2.3) $$\oint_{\Gamma}(\mu \nabla \psi_I) \cdot \hat{n} + \int_{\Omega}- \nabla \mu\cdot \nabla \psi_I$$

Similarly for *Eq 3.2.3*

3.2.3.2) $$\int_{\Omega} \nabla \cdot(\mu \gamma^2 \psi_R \nabla \varphi) + \int_{\Omega}-\gamma^2 \psi_R \nabla \varphi\nabla\mu + \int_{\Omega}-\gamma^2 \mu \nabla \varphi\nabla\psi_R$$

Similarly applying the divergence theorem we get,

3.2.3.3) $$\oint_{\Gamma} (\mu \gamma^2 \psi_R \nabla \varphi) \cdot \hat{n} + \int_{\Omega}-\gamma^2 \psi_R \nabla \varphi\nabla\mu + \int_{\Omega}-\gamma^2 \mu \nabla \varphi\nabla\psi_R$$

Combining these recombining these equations for *3.2* in kernel form,

4.2) $$0=\Biggl( \mu , \Bigl(-u \sqrt{1+\gamma^2\left(\psi_R^2+\psi_I^2\right)}\left(\frac{\partial}{\partial t} \psi_I+\varphi \psi_R\right)\Bigl)\Biggl) \\ + \Biggl \lang \mu , \nabla \psi_I  \Biggl\rang  + \Biggl(\nabla \mu, - \nabla \psi_I \Biggl) \\+ \Biggl\lang \mu,  \gamma^2 \psi_R \nabla \varphi \cdot \hat{n}  \Biggl\rang +\Biggl(\nabla \mu ,-\gamma^2 \psi_R \nabla \varphi \Biggl)  + \Biggl(\mu, -\gamma^2 \nabla \varphi\nabla\psi_R \Biggl) \\ +\Biggl( \mu, (1-\psi_R^2-\psi_I^2) \psi_I \Biggl)$$

Repeating the process for *2.3*,


2.3.1) $$\mu \Biggl(\nabla^2 \varphi-\psi_R \nabla^2 \psi_I+\psi_I \nabla^2 \psi_R \Biggl) = 0, \forall \mu$$

2.3.2) $$\int_{\Omega}\mu \Biggl(\nabla^2 \varphi-\psi_R \nabla^2 \psi_I+\psi_I \nabla^2 \psi_R \Biggl) = 0$$

2.3.3) $$\int_{\Omega}\mu \Bigl(\nabla^2 \varphi\Bigl) + \int_{\Omega}\mu\Bigl(-\psi_R \nabla^2 \psi_I\Bigl)+\int_{\Omega}\mu\Bigl(\psi_I \nabla^2 \psi_R\Bigl) = 0$$

Separating these we get,

3.3.1) $$\int_{\Omega}\mu \Bigl(\nabla^2 \varphi\Bigl)$$

3.3.2) $$\int_{\Omega}\mu\Bigl(-\psi_R \nabla^2 \psi_I\Bigl)$$

3.3.3) $$\int_{\Omega}\mu\Bigl(\psi_I \nabla^2 \psi_R\Bigl)$$

Applying the product rule to *3.3.1*:

3.3.1.1) $$ \mu(\nabla^2 \varphi) = \nabla \cdot(\mu \nabla \varphi) - \nabla \mu\cdot \nabla \varphi$$

Applying the product rule to *3.3.2*:

3.3.2.1) $$ \mu(-\psi_R \nabla^2 \psi_I) = -\nabla \cdot(\mu \psi_R \nabla \psi_I)+  \psi_R \nabla \psi_I\cdot\nabla\mu +  \mu \nabla \psi_I\cdot\nabla\psi_R   $$

Applying the product rule to *3.3.3*:

3.3.3.1) $$ \mu(\psi_I \nabla^2 \psi_R) = \nabla \cdot(\mu \psi_I \nabla \psi_R)-  \psi_I \nabla \psi_R\cdot\nabla\mu -  \mu \nabla \psi_R\cdot\nabla\psi_I   $$


Performing the integral on *Eq 3.3.1.1*

3.3.1.2) $$\int_{\Omega}\nabla \cdot(\mu \nabla \varphi) + \int_{\Omega}- \nabla \mu\cdot \nabla \varphi$$

By applying the divergence theorem we get,

3.3.1.3) $$\oint_{\Gamma}(\mu \nabla \varphi) \cdot \hat{n} + \int_{\Omega}- \nabla \mu\cdot \nabla \varphi$$

Similarly for *Eq 3.3.2.1*

3.3.2.2) $$\int_{\Omega} -\nabla \cdot(\mu \psi_R \nabla \psi_I) + \int_{\Omega} \psi_R \nabla \psi_I\cdot\nabla\mu + \int_{\Omega} \mu \nabla \psi_I\cdot\nabla\psi_R$$

Similarly applying the divergence theorem we get,

3.3.2.3) $$\oint_{\Gamma} (-\mu \psi_R \nabla \psi_I) \cdot \hat{n} + \int_{\Omega} \psi_R \nabla \psi_I\cdot\nabla\mu + \int_{\Omega} \mu \nabla \psi_I\cdot\nabla\psi_R$$

Similarly for *Eq 3.3.3.1*

3.3.3.2) $$\int_{\Omega} \nabla \cdot(\mu \psi_I \nabla \psi_R) + \int_{\Omega} -\psi_I \nabla \psi_R\cdot\nabla\mu + \int_{\Omega}- \mu \nabla \psi_R\cdot\nabla\psi_I$$

Similarly applying the divergence theorem we get,

3.3.3.3) $$\oint_{\Gamma} (\mu \psi_I \nabla \psi_R) \cdot \hat{n} + \int_{\Omega} -\psi_I \nabla \psi_R\cdot\nabla\mu + \int_{\Omega}- \mu \nabla \psi_R\cdot\nabla\psi_I$$

Combining these recombining these equations for *3.3* in kernel form,

4.3) 
$$ 0 = \Biggl \lang \mu, \nabla \varphi \cdot \hat{n}\Biggl \rang + \Biggl( \nabla \mu, -\nabla \varphi \Biggl) \\
+ \Biggl \lang \mu, - \psi_R \nabla \psi_I \cdot \hat{n}\Biggl \rang + \Biggl( \nabla \mu,\psi_R \nabla \psi_I \Biggl) + \Biggl(  \mu,\nabla \psi_I \cdot \nabla \psi_R \Biggl) \\
+ \Biggl \lang \mu, \psi_I \nabla \psi_R \cdot \hat{n}\Biggl \rang + \Biggl( \nabla \mu,-\psi_I \nabla \psi_R \Biggl) + \Biggl(  \mu,-\nabla \psi_R \cdot \nabla \psi_I \Biggl)$$


Now for *Eq 2.4*. Note that this is solved in vector form,

2.4.1)$$0=\underline{j}+\nabla \varphi-\psi_R \nabla \psi_I+\psi_I \nabla \psi_R$$

2.4.2)$$\mu \Biggl(\underline{j}+\nabla \varphi-\psi_R \nabla \psi_I+\psi_I \nabla \psi_R \Biggl) = 0, \forall \mu$$

2.4.3)$$\int_{\Omega}\mu \Biggl(\underline{j}+\nabla \varphi-\psi_R \nabla \psi_I+\psi_I \nabla \psi_R \Biggl) = 0$$

2.4.4)
$$\int_{\Omega}\mu \Bigl(\underline{j}\Bigl) + \int_{\Omega}\mu\Bigl(\nabla \varphi\Bigl)+\int_{\Omega}\mu\Bigl(
-\psi_R \nabla \psi_I\Bigl)+\int_{\Omega}\mu\Bigl(
\psi_I \nabla \psi_R\Bigl) = 0$$

Thankfully there is no need to reduce the integration order this time, so this can all be considered as one,

4.4) $$ 0 =  \Biggl( \mu,\underline{j}+\nabla \varphi-\psi_R \nabla \psi_I+\psi_I \nabla \psi_R\Biggl)$$

