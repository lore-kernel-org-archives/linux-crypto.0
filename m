From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [RFC PATCH 0/2] crypto: caam - fix cts(cbc(aes)) with CAAM driver
Date: Fri, 16 Jun 2017 07:57:00 +0000
Message-ID: <VI1PR0401MB25913AAA76159D27E8EB13DF98C10@VI1PR0401MB2591.eurprd04.prod.outlook.com>
References: <20170602122446.2427-1-david@sigma-star.at>
 <VI1PR0401MB25910B19DB95DABF62C00A7598C00@VI1PR0401MB2591.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: "richard@sigma-star.at" <richard@sigma-star.at>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: David Gstir <david@sigma-star.at>,
        Dan Douglass <dan.douglass@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Radu Solea <radu.solea@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ve1eur01on0044.outbound.protection.outlook.com ([104.47.1.44]:14930
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752418AbdFPH5E (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Jun 2017 03:57:04 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 6/15/2017 5:57 PM, Horia Geant=E3 wrote:=0A=
> On 6/2/2017 3:25 PM, David Gstir wrote:=0A=
>> Hi!=0A=
>>=0A=
>> While testing fscrypt's filename encryption, I noticed that the implemen=
tation=0A=
>> of cts(cbc(aes)) is broken when the CAAM hardware crypto driver is enabl=
ed.=0A=
>> Some digging showed that the refactoring of crypto/cts.c in v4.8 =0A=
>> (commit 0605c41cc53ca) exposed some problems with CAAM's aes-cbc=0A=
>> implementation. This can be tested quite easily by loading the tcrypt=0A=
>> module with mode=3D38. Looks like the cts mode is not used very often=0A=
>> and this went unnoticed since 4.8...=0A=
>>=0A=
>> This patch series is an attempt to fix that and get cts(cbc(aes)) workin=
g=0A=
>> properly again when the CAAM driver is enabled.=0A=
>>=0A=
> David, thanks for taking time to fix these.=0A=
> =0A=
>> Specifically, the issues are:=0A=
[snip]=0A=
>> 2) The cts implementation uses aes-cbc twice to perform its job. The sec=
ond=0A=
>>    time, it is called from within the callback of the first call to aes-=
cbc.=0A=
>>    This usage is not properly handled in the CAAM driver which triggers =
the=0A=
>>    BUG below.=0A=
>>=0A=
> Dan, Radu - have you seen this on i.MX?=0A=
> =0A=
>>    My current proposal is to use in_interrupt() to detect such cases and=
 set=0A=
>>    the k*alloc flags accordingly. However, since using in_interrupt() is=
 not=0A=
>>    really nice, I'm wondering if there is a better way to handle this?=
=0A=
>>=0A=
> Nothing else crosses my mind right now, but I'd like to sleep on it.=0A=
> =0A=
Herbert,=0A=
=0A=
Commit 0605c41cc53ca ("crypto: cts - Convert to skcipher") appends=0A=
CRYPTO_TFM_REQ_MAY_BACKLOG to the original crypto request flags for the=0A=
last block - when calling cts_cbc_encrypt().=0A=
Is it really needed?=0A=
=0A=
For cts(cbc(aes)) with cbc(aes) offloaded in HW, i.e. running in async=0A=
mode, we get the below stack for CAAM driver.=0A=
Driver is told that it can sleep (CRYPTO_TFM_REQ_MAY_BACKLOG flag), so=0A=
it uses GFP_KERNEL to allocate memory. However, this is incorrect, since=0A=
driver runs in atomic context (softirq).=0A=
=0A=
I wouldn't say that:=0A=
-David's suggestion - adding in_interrupt()=0A=
- or in general: trying to detect in CAAM driver whether we are in=0A=
atomic context using anything else than what crypto API provides=0A=
(MAY_BACKLOG, MAY_SLEEP flags)=0A=
=0A=
is something we want to do.=0A=
IIUC, in general caller (cts / crypto API) is responsible for telling=0A=
the callee if it will run in atomic context or not:=0A=
https://lwn.net/Articles/274695/=0A=
=0A=
Thanks,=0A=
Horia=0A=
=0A=
>> <snip>=0A=
>> [  126.252543] BUG: sleeping function called from invalid context at mm/=
slab.h:432=0A=
>> [  126.260099] in_atomic(): 1, irqs_disabled(): 0, pid: 0, name: swapper=
/0=0A=
>> [  126.266837] no locks held by swapper/0/0.=0A=
>> [  126.270969] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.12.0-rc3-0005=
2-g0ddec680d395 #287=0A=
>> [  126.279226] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree=
)=0A=
>> [  126.285821] Backtrace:=0A=
>> [  126.288406] [<c010c3e4>] (dump_backtrace) from [<c010c690>] (show_sta=
ck+0x18/0x1c)=0A=
>> [  126.296057]  r7:00000000 r6:60000113 r5:00000000 r4:c102ab48=0A=
>> [  126.301798] [<c010c678>] (show_stack) from [<c0427060>] (dump_stack+0=
xb4/0xe8)=0A=
>> [  126.309106] [<c0426fac>] (dump_stack) from [<c014f020>] (___might_sle=
ep+0x17c/0x2a0)=0A=
>> [  126.316929]  r9:00000000 r8:c0a016dc r7:c101ee3e r6:000001b0 r5:c0c12=
fac r4:ffffe000=0A=
>> [  126.324751] [<c014eea4>] (___might_sleep) from [<c014f1a8>] (__might_=
sleep+0x64/0xa4)=0A=
>> [  126.332655]  r7:014080c1 r6:00000000 r5:000001b0 r4:c0c12fac=0A=
>> [  126.338397] [<c014f144>] (__might_sleep) from [<c0224a20>] (__kmalloc=
+0x130/0x1b8)=0A=
>> [  126.346039]  r6:c071a8ec r5:014080c1 r4:eec01e00=0A=
>> [  126.350742] [<c02248f0>] (__kmalloc) from [<c071a8ec>] (ablkcipher_ed=
esc_alloc.constprop.1+0x200/0x900)=0A=
>> [  126.360213]  r10:00000000 r9:00000000 r8:c0a016dc r7:c0a016dc r6:ee05=
ac10 r5:edfdaec0=0A=
>> [  126.368109]  r4:00000001 r3:00000020=0A=
>> [  126.371765] [<c071a6ec>] (ablkcipher_edesc_alloc.constprop.1) from [<=
c071b010>] (ablkcipher_encrypt+0x24/0x9c)=0A=
>> [  126.381843]  r10:00000000 r9:00000020 r8:00000001 r7:ee05ac10 r6:ed59=
7000 r5:edfdaec0=0A=
>> [  126.389738]  r4:ed475d08=0A=
>> [  126.392354] [<c071afec>] (ablkcipher_encrypt) from [<c03d6f20>] (skci=
pher_encrypt_ablkcipher+0x68/0x6c)=0A=
>> [  126.401822]  r7:ed475d08 r6:ed597000 r5:00000400 r4:ed475d08=0A=
>> [  126.407566] [<c03d6eb8>] (skcipher_encrypt_ablkcipher) from [<c03e8a7=
0>] (cts_cbc_encrypt+0x118/0x124)=0A=
>> [  126.416947]  r7:ed475d08 r6:c1001cc0 r5:00000010 r4:edfdae00=0A=
>> [  126.422686] [<c03e8958>] (cts_cbc_encrypt) from [<c03e8b88>] (crypto_=
cts_encrypt_done+0x20/0x54)=0A=
>> [  126.431548]  r10:00000000 r9:ee05ac10 r8:00000000 r7:00000010 r6:edc8=
e6c0 r5:edc8e6d8=0A=
>> [  126.439443]  r4:edfdae00=0A=
>> [  126.442056] [<c03e8b68>] (crypto_cts_encrypt_done) from [<c07195a0>] =
(ablkcipher_encrypt_done+0x88/0x9c)=0A=
>> [  126.445180] fec 2188000.ethernet eth0: MDIO read timeout=0A=
>> [  126.456948]  r5:edc8e6d8 r4:edfdaec0=0A=
>> [  126.460604] [<c0719518>] (ablkcipher_encrypt_done) from [<c0715ca0>] =
(caam_jr_dequeue+0x214/0x2d4)=0A=
>> [  126.469639]  r9:00000001 r8:ee088010 r7:000001ff r6:00000001 r5:00000=
000 r4:edfdaec0=0A=
>> [  126.477467] [<c0715a8c>] (caam_jr_dequeue) from [<c012b3f0>] (tasklet=
_action+0x98/0x154)=0A=
>> [  126.485160] fec 2188000.ethernet eth0: MDIO read timeout=0A=
>> [  126.490975]  r10:c1080b80 r9:c1008b84 r8:00000000 r7:c1000000 r6:0000=
0000 r5:ee088028=0A=
>> [  126.498870]  r4:ee088024=0A=
>> [  126.501484] [<c012b358>] (tasklet_action) from [<c012b60c>] (__do_sof=
tirq+0xf0/0x2a4)=0A=
>> [  126.509390]  r10:40000006 r9:c1002080 r8:00000101 r7:c1002098 r6:c100=
0000 r5:00000006=0A=
>> [  126.517285]  r4:00000000=0A=
>> [  126.519896] [<c012b51c>] (__do_softirq) from [<c012bb90>] (irq_exit+0=
xec/0x168)=0A=
>> [  126.525127] fec 2188000.ethernet eth0: MDIO write timeout=0A=
>> [  126.532709]  r10:c1008cf0 r9:eec08400 r8:00000001 r7:00000000 r6:c100=
8b84 r5:00000000=0A=
>> [  126.540603]  r4:c0fd940c=0A=
>> [  126.543222] [<c012baa4>] (irq_exit) from [<c017ff24>] (__handle_domai=
n_irq+0x74/0xe8)=0A=
>> [  126.551135] [<c017feb0>] (__handle_domain_irq) from [<c01015fc>] (gic=
_handle_irq+0x58/0xbc)=0A=
>> [  126.559564]  r9:f4000100 r8:c102af80 r7:c1001ea8 r6:000003ff r5:00000=
3eb r4:f400010c=0A=
>> [  126.567384] [<c01015a4>] (gic_handle_irq) from [<c010d2f0>] (__irq_sv=
c+0x70/0x98)=0A=
>> [  126.574937] Exception stack(0xc1001ea8 to 0xc1001ef0)=0A=
>> [  126.580065] 1ea0:                   00000001 2e39a000 00000000 c100c0=
80 00000000 ef374698=0A=
>> [  126.588320] 1ec0: 653b20b1 0000001d 653afed6 0000001d 00000000 c1001f=
24 c1001ec8 c1001ef8=0A=
>> [  126.596568] 1ee0: c016fcf4 c06f1fbc 20000013 ffffffff=0A=
>> [  126.601696]  r10:00000000 r9:c1000000 r8:653afed6 r7:c1001edc r6:ffff=
ffff r5:20000013=0A=
>> [  126.609591]  r4:c06f1fbc=0A=
>> [  126.612210] [<c06f1e34>] (cpuidle_enter_state) from [<c06f2120>] (cpu=
idle_enter+0x1c/0x20)=0A=
>> [  126.620551]  r10:c100f8c0 r9:ef374698 r8:c1008b84 r7:c0fda690 r6:c100=
89ec r5:c1008a38=0A=
>> [  126.628448]  r4:c1000000 r3:ef374698=0A=
>> [  126.632114] [<c06f2104>] (cpuidle_enter) from [<c0167330>] (call_cpui=
dle+0x28/0x44)=0A=
>> [  126.639859] [<c0167308>] (call_cpuidle) from [<c0167608>] (do_idle+0x=
1ac/0x220)=0A=
>> [  126.647249] [<c016745c>] (do_idle) from [<c0167a20>] (cpu_startup_ent=
ry+0x20/0x24)=0A=
>> [  126.654895]  r10:c0e60a50 r9:efffc940 r8:c1080000 r7:c10089c0 r6:c108=
0000 r5:00000002=0A=
>> [  126.662793]  r4:000000bd r3:c0e733c4=0A=
>> [  126.666457] [<c0167a00>] (cpu_startup_entry) from [<c09cfbd4>] (rest_=
init+0x154/0x198)=0A=
>> [  126.674463] [<c09cfa80>] (rest_init) from [<c0e00cf0>] (start_kernel+=
0x344/0x3b8)=0A=
>> [  126.682015]  r5:ffffffff r4:c108004c=0A=
>> [  126.685668] [<c0e009ac>] (start_kernel) from [<1000807c>] (0x1000807c=
)=0A=
>> </snip>=0A=
>>=0A=
>>   crypto: caam - properly set IV after {en,de}crypt=0A=
>>   crypto: caam - fix k*alloc if called from own cipher callback=0A=
>>=0A=
>>  drivers/crypto/caam/caamalg.c | 55 +++++++++++++++++++++++++++++++++++-=
-------=0A=
>>  1 file changed, 45 insertions(+), 10 deletions(-)=0A=
>>=0A=
