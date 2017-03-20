From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: Re: [RFC PATCH v4] IV Generation algorithms for dm-crypt
Date: Mon, 20 Mar 2017 20:01:56 +0530
Message-ID: <CAHv-k_8Tcb9d0eRPuOZyVgh=p2c1WyfYrf96bZCf9=Zm0-STKw@mail.gmail.com>
References: <1486463731-6224-1-git-send-email-binoy.jayan@linaro.org>
	<CAOtvUMcN8s886978vE6T=AE79KkZsLBnXsmhewnb5PB0UyAG3A@mail.gmail.com>
	<CAHv-k_8rgArzV2uQ64h1ZTNRpssX1jMf=RwuPoBmsjQ0FhCsWA@mail.gmail.com>
	<68f70534-a309-46ba-a84d-8acc1e6620e5@gmail.com>
	<CAOtvUMf3c0fUjABmbfMrbs0W4gyhKVZyc_tZH3rQg65zF18YMg@mail.gmail.com>
	<b563eb97-82ba-69d2-c4c5-66bc716a7507@gmail.com>
	<CAOtvUMePYT7OJDKL7i0y3y6Jvqsxyx6Je6g9aGKVq6PLZ_-Z8w@mail.gmail.com>
	<2aef6e54-805f-e09b-ae66-c198f8c05335@gmail.com>
	<c835926e-c2bd-8a52-34db-6c605301bc2b@gmail.com>
	<CAOtvUMdrQA4okKhiCyVmosQ4Oc2PHO4k4wLrDz-_fCyWB1rWBw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2271408809661336662=="
Cc: Rajendra <rnayak@codeaurora.org>, Herbert Xu <herbert@gondor.apana.org.au>,
	Oded <oded.golombek@arm.com>, Ondrej Mosnacek <omosnace@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>,
	Linux kernel mailing list <linux-kernel@vger.kernel.org>,
	Milan Broz <gmazyland@gmail.com>, linux-raid@vger.kernel.org,
	dm-devel@redhat.com, Mark Brown <broonie@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
	Shaohua Li <shli@kernel.org>, "David S. Miller" <davem@davemloft.net>,
	Alasdair Kergon <agk@redhat.com>, Ofir <Ofir.Drang@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAOtvUMdrQA4okKhiCyVmosQ4Oc2PHO4k4wLrDz-_fCyWB1rWBw@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-crypto.vger.kernel.org

--===============2271408809661336662==
Content-Type: multipart/alternative; boundary=001a114e1d94b6ab1f054b2a639b

--001a114e1d94b6ab1f054b2a639b
Content-Type: text/plain; charset=UTF-8

Hi,

On 8 March 2017 at 13:49, Binoy Jayan <binoy.jayan@linaro.org> wrote:
> Hi Gilad,
>
>> I gave it a spin on a x86_64 with 8 CPUs with AES-NI using cryptd and
>> on Arm  using CryptoCell hardware accelerator.
>>
>> There was no difference in performance between 512 and 4096 bytes
>> cluster size on the x86_64 (800 MB loop file system)
>>
>> There was an improvement in latency of 3.2% between 512 and 4096 bytes
>> cluster size on the Arm. I expect the performance benefits for this
>> test for Binoy's patch to be the same.
>>
>> In both cases the very naive test was a simple dd with block size of
>> 4096 bytes or the raw block device.
>>
>> I do not know what effect having a bigger cluster size would have on
>> have on other more complex file system operations.
>> Is there any specific benchmark worth testing with?

The multiple instances issue in /proc/crypto is fixed. It was because of
the IV code itself modifying the algorithm name inadvertently in the
global crypto algorithm lookup table when it was splitting up
"plain(cbc(aes))" into "plain" and "cbc(aes)" so as to invoke the child
algorithm.

I ran a few tests with dd, bonnie and FIO under Qemu - x86 using the
automated script [1] that I wrote to make the testing easy.
The tests were done on software implementations of the algorithms
as the real hardware was not available with me. According to the test,
I found that the sequential reads and writes have a good improvement
(5.7 %) in the data rate with the proposed solution while the random
reads shows a very little improvement. When tested with FIO, the
random writes also shows a small improvement (2.2%) but the random
reads show a little deterioration in performance (4 %).

When tested in arm hardware, only the sequential writes with bonnie
shows improvement (5.6%). All other tests shows degraded performance
in the absence of crypto hardware.

[1] https://github.com/binoyjayan/utilities/blob/master/utils/dmtest
Dependencies: dd [Full version], bonnie, fio

Thanks,
Binoy

--001a114e1d94b6ab1f054b2a639b
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi,<br><br>On 8 March 2017 at 13:49, Binoy Jayan &lt;=
<a href=3D"mailto:binoy.jayan@linaro.org" target=3D"_blank">binoy.jayan@lin=
aro.org</a>&gt; wrote:<br>&gt; Hi Gilad,<br>&gt;<br>&gt;&gt; I gave it a sp=
in on a x86_64 with 8 CPUs with AES-NI using cryptd and<br>&gt;&gt; on Arm=
=C2=A0 using CryptoCell hardware accelerator.<br>&gt;&gt;<br>&gt;&gt; There=
 was no difference in performance between 512 and 4096 bytes<br>&gt;&gt; cl=
uster size on the x86_64 (800 MB loop file system)<br>&gt;&gt;<br>&gt;&gt; =
There was an improvement in latency of 3.2% between 512 and 4096 bytes<br>&=
gt;&gt; cluster size on the Arm. I expect the performance benefits for this=
<br>&gt;&gt; test for Binoy&#39;s patch to be the same.<br>&gt;&gt;<br>&gt;=
&gt; In both cases the very naive test was a simple dd with block size of<b=
r>&gt;&gt; 4096 bytes or the raw block device.<br>&gt;&gt;<br>&gt;&gt; I do=
 not know what effect having a bigger cluster size would have on<br>&gt;&gt=
; have on other more complex file system operations.<br>&gt;&gt; Is there a=
ny specific benchmark worth testing with?<br><br>The multiple instances iss=
ue in /proc/crypto is fixed. It was because of<br>the IV code itself modify=
ing the algorithm name inadvertently in the<br>global crypto algorithm look=
up table when it was splitting up<br>&quot;plain(cbc(aes))&quot; into &quot=
;plain&quot; and &quot;cbc(aes)&quot; so as to invoke the child<br>algorith=
m.<br><br>I ran a few tests with dd, bonnie and FIO under Qemu - x86 using =
the<br>automated script [1] that I wrote to make the testing easy.<br>The t=
ests were done on software implementations of the algorithms<br>as the real=
 hardware was not available with me. According to the test,<br>I found that=
 the sequential reads and writes have a good improvement<br>(5.7 %) in the =
data rate with the proposed solution while the random<br>reads shows a very=
 little improvement. When tested with FIO, the<br>random writes also shows =
a small improvement (2.2%) but the random<br>reads show a little deteriorat=
ion in performance (4 %).<br>=C2=A0<br></div><div>When tested in arm hardwa=
re, only the sequential writes with bonnie<br>shows improvement (5.6%). All=
 other tests shows degraded performance<br></div><div>in the absence of cry=
pto hardware.<br></div><div><br>[1] <a href=3D"https://github.com/binoyjaya=
n/utilities/blob/master/utils/dmtest" target=3D"_blank">https://github.com/=
binoyjayan/<wbr>utilities/blob/master/utils/dm<wbr>test</a><br></div>Depend=
encies: dd [Full version], bonnie, fio<br><div><br>Thanks,<br>Binoy<br><br>=
</div></div>

--001a114e1d94b6ab1f054b2a639b--


--===============2271408809661336662==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2271408809661336662==--
