From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH 4.14, 4.9] crypto: talitos - fix Kernel Oops on hashing an
 empty file
Date: Thu, 22 Feb 2018 08:30:56 +0000
Message-ID: <AM0PR0402MB3329F7DB21610C75674BA7AD98CD0@AM0PR0402MB3329.eurprd04.prod.outlook.com>
References: <20180222070616.A15E36CBD4@po15720vm.idsi0.si.c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Christophe Leroy <christophe.leroy@c-s.fr>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Id: linux-crypto.vger.kernel.org

On 2/22/2018 9:08 AM, Christophe Leroy wrote:=0A=
> Upstream 87a81dce53b1ea61acaeefa5191a0376a2d1d721=0A=
> =0A=
> Performing the hash of an empty file leads to a kernel Oops=0A=
> =0A=
> [   44.504600] Unable to handle kernel paging request for data at address=
 0x0000000c=0A=
> [   44.512819] Faulting instruction address: 0xc02d2be8=0A=
> [   44.524088] Oops: Kernel access of bad area, sig: 11 [#1]=0A=
> [   44.529171] BE PREEMPT CMPC885=0A=
> [   44.532232] CPU: 0 PID: 491 Comm: md5sum Not tainted 4.15.0-rc8-00211-=
g3a968610b6ea #81=0A=
> [   44.540814] NIP:  c02d2be8 LR: c02d2984 CTR: 00000000=0A=
> [   44.545812] REGS: c6813c90 TRAP: 0300   Not tainted  (4.15.0-rc8-00211=
-g3a968610b6ea)=0A=
> [   44.554223] MSR:  00009032 <EE,ME,IR,DR,RI>  CR: 48222822  XER: 200000=
00=0A=
> [   44.560855] DAR: 0000000c DSISR: c0000000=0A=
> [   44.560855] GPR00: c02d28fc c6813d40 c6828000 c646fa40 00000001 000000=
01 00000001 00000000=0A=
> [   44.560855] GPR08: 0000004c 00000000 c000bfcc 00000000 28222822 100280=
d4 00000000 10020008=0A=
> [   44.560855] GPR16: 00000000 00000020 00000000 00000000 10024008 000000=
00 c646f9f0 c6179a10=0A=
> [   44.560855] GPR24: 00000000 00000001 c62f0018 c6179a10 00000000 c6367a=
30 c62f0000 c646f9c0=0A=
> [   44.598542] NIP [c02d2be8] ahash_process_req+0x448/0x700=0A=
> [   44.603751] LR [c02d2984] ahash_process_req+0x1e4/0x700=0A=
> [   44.608868] Call Trace:=0A=
> [   44.611329] [c6813d40] [c02d28fc] ahash_process_req+0x15c/0x700 (unrel=
iable)=0A=
> [   44.618302] [c6813d90] [c02060c4] hash_recvmsg+0x11c/0x210=0A=
> [   44.623716] [c6813db0] [c0331354] ___sys_recvmsg+0x98/0x138=0A=
> [   44.629226] [c6813eb0] [c03332c0] __sys_recvmsg+0x40/0x84=0A=
> [   44.634562] [c6813f10] [c03336c0] SyS_socketcall+0xb8/0x1d4=0A=
> [   44.640073] [c6813f40] [c000d1ac] ret_from_syscall+0x0/0x38=0A=
> [   44.645530] Instruction dump:=0A=
> [   44.648465] 38c00001 7f63db78 4e800421 7c791b78 54690ffe 0f090000 80ff=
0190 2f870000=0A=
> [   44.656122] 40befe50 2f990001 409e0210 813f01bc <8129000c> b39e003a 7d=
29c214 913e003c=0A=
> =0A=
> This patch fixes that Oops by checking if src is NULL.=0A=
> =0A=
> Fixes: 6a1e8d14156d4 ("crypto: talitos - making mapping helpers more gene=
ric")=0A=
> Cc: <stable@vger.kernel.org>=0A=
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>=0A=
=0A=
Isn't this needed also in 4.15.y?=0A=
=0A=
Thanks,=0A=
Horia=0A=
