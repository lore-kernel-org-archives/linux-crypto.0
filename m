From: Paul Wouters <paul@nohats.ca>
Subject: Re: [Openswan Users] Openswan IPsec: ARM cortex SoC board to board
 ping works but board to Ubuntu does not
Date: Fri, 2 Mar 2012 08:57:09 -0500 (EST)
Message-ID: <alpine.LFD.2.02.1203020853410.7465@bofh.nohats.ca>
References: <CAGgcXb7dMetJ0OS498X9Fn3Py6OAfWhN2j+kA1HzyJFzbfJ_tg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Cc: users@openswan.org, linux-crypto@vger.kernel.org
To: satpal parmar <systems.satpal@gmail.com>
Return-path: <users-bounces@lists.openswan.org>
In-Reply-To: <CAGgcXb7dMetJ0OS498X9Fn3Py6OAfWhN2j+kA1HzyJFzbfJ_tg@mail.gmail.com>
List-Unsubscribe: <https://lists.openswan.org/mailman/options/users>,
	<mailto:users-request@lists.openswan.org?subject=unsubscribe>
List-Archive: <https://lists.openswan.org/pipermail/users/>
List-Post: <mailto:users@lists.openswan.org>
List-Help: <mailto:users-request@lists.openswan.org?subject=help>
List-Subscribe: <https://lists.openswan.org/mailman/listinfo/users>,
	<mailto:users-request@lists.openswan.org?subject=subscribe>
Sender: users-bounces@lists.openswan.org
Errors-To: users-bounces@lists.openswan.org
List-Id: linux-crypto.vger.kernel.org

On Fri, 2 Mar 2012, satpal parmar wrote:

>
> I recently ported Openswan on ARM cortex based SOC running linux
> 2.6.37 (ipsec netkey stack) and openswan 2.6.23. On this board I have
> H/W accelerator support for AES/DES/SHA.
> (http://processors.wiki.ti.com/index.php/Installing_AM387x_C6A814x_DM814x_Crypto_Support).
> AES/DES crypto operation are working fine and I am able to ping
> through IPsec tunnel from my board to PC and vice versa.

Did you need to patch anything for openswan? Can you share your patches
with us?

> However when
> I am trying ping with SHA-MD5 I am not able to ping  to and from
> Ubuntu machine .


> My ubuntu machine details:
> root@vnl-desktop:~# uname -a
> Linux vnl-desktop 2.6.32-33-generic #72-Ubuntu SMP Fri Jul 29 21:08:37
> UTC 2011 i686 GNU/Linux
>
> MYost probably it could be a IPsec configuration issue on Ubuntu
> machine but I am not able to locate  what configuration could affect
> behavior of only one crypto algorithm. Since I am using same
> configuration for IPsec for testing all Crypto algo supported in H/W
> (DES/AES/SHA-MD5 )and  I am successfully able to ping through IPSec
> tunnel for DES and AES.

I am not sure what you mean when you bundle "sha-md5" and "des and aes".
A tunnel needs both an encryption algorithm (aes or 3des) and an
authentication algothim (sha1, sha2, md5, etc). So for your tunnel
to work, you would always be using either md5 or sha? Since you say
some tunnels work, those algorithms must be working?

I am not sure I understand exacly what works and what does not work.

Paul
_______________________________________________
Users@lists.openswan.org
https://lists.openswan.org/mailman/listinfo/users
Micropayments: https://flattr.com/thing/38387/IPsec-for-Linux-made-easy
Building and Integrating Virtual Private Networks with Openswan:
http://www.amazon.com/gp/product/1904811256/104-3099591-2946327?n=283155
