From: satpal parmar <systems.satpal@gmail.com>
Subject: Re: [Openswan Users] Openswan IPsec: ARM cortex SoC board to board
 ping works but board to Ubuntu does not
Date: Mon, 5 Mar 2012 08:21:31 +0530
Message-ID: <CAGgcXb4WUxOBYn46kTX13HAD-3BT9hxDD+svx1BB-kC-oMuf3w@mail.gmail.com>
References: <CAGgcXb7dMetJ0OS498X9Fn3Py6OAfWhN2j+kA1HzyJFzbfJ_tg@mail.gmail.com>
	<alpine.LFD.2.02.1203020853410.7465@bofh.nohats.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: users@openswan.org, linux-crypto@vger.kernel.org
Return-path: <users-bounces@lists.openswan.org>
In-Reply-To: <alpine.LFD.2.02.1203020853410.7465@bofh.nohats.ca>
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

Sorry for that confusion Paul. Yes you are right we need both an
encryption algorithm and and authentication algorithm for  IPsec to
work. As per my understanding we can do this either in H/W through
some security engine or accelerators or through s/w libraries already
supported in Linux. IPsec stack will first look for H/W  support and
if it fails it will fall back to s/w libraries.

On my SOC we have H/W support for AES/DES/SHA-MD5 with driver support
from TI. So when I say ping works with AES/DES I mean I see ESP
packets going and received both side in wireshark when I ping board to
PC(Ubuntu) or vice versa. So from above understanding I assume what is
happening is encryption is handled by AES/DES hardware and
authentication is been done in S/W. (Is there any better way to
confirm other then wireshark ?)

But when I include SHA-MD5 h/w driver support this arrangement fail to
work. I do see ESP packets going from board and Ubuntu side but none
of the sides are able to  receive/handle these esp packets. This
configuration /ping works fine  when I connect another board in place
of Ubuntu on other side . It's a strange behavior I am trying to
debug.

I think David can help us in understanding this situation better?

@David: Hello David! Hope you are doing fine. I am back to bug you
again! Please have a look at this mail and let me know if my
explanation of behavior is consistent with your understanding of
IPsec.

Thanks for your response everyone. I will update if I make any
progress on this issue.

-SP


On Fri, Mar 2, 2012 at 7:27 PM, Paul Wouters <paul@nohats.ca> wrote:
> On Fri, 2 Mar 2012, satpal parmar wrote:
>
>>
>> I recently ported Openswan on ARM cortex based SOC running linux
>> 2.6.37 (ipsec netkey stack) and openswan 2.6.23. On this board I have
>> H/W accelerator support for AES/DES/SHA.
>>
>> (http://processors.wiki.ti.com/index.php/Installing_AM387x_C6A814x_DM814=
x_Crypto_Support).
>> AES/DES crypto operation are working fine and I am able to ping
>> through IPsec tunnel from my board to PC and vice versa.
>
>
> Did you need to patch anything for openswan? Can you share your patches
> with us?
>
>
>> However when
>> I am trying ping with SHA-MD5 I am not able to ping =A0to and from
>> Ubuntu machine .
>
>
>
>> My ubuntu machine details:
>> root@vnl-desktop:~# uname -a
>> Linux vnl-desktop 2.6.32-33-generic #72-Ubuntu SMP Fri Jul 29 21:08:37
>> UTC 2011 i686 GNU/Linux
>>
>> MYost probably it could be a IPsec configuration issue on Ubuntu
>> machine but I am not able to locate =A0what configuration could affect
>> behavior of only one crypto algorithm. Since I am using same
>> configuration for IPsec for testing all Crypto algo supported in H/W
>> (DES/AES/SHA-MD5 )and =A0I am successfully able to ping through IPSec
>> tunnel for DES and AES.
>
>
> I am not sure what you mean when you bundle "sha-md5" and "des and aes".
> A tunnel needs both an encryption algorithm (aes or 3des) and an
> authentication algothim (sha1, sha2, md5, etc). So for your tunnel
> to work, you would always be using either md5 or sha? Since you say
> some tunnels work, those algorithms must be working?
>
> I am not sure I understand exacly what works and what does not work.
>
> Paul
_______________________________________________
Users@lists.openswan.org
https://lists.openswan.org/mailman/listinfo/users
Micropayments: https://flattr.com/thing/38387/IPsec-for-Linux-made-easy
Building and Integrating Virtual Private Networks with Openswan:
http://www.amazon.com/gp/product/1904811256/104-3099591-2946327?n=3D283155
