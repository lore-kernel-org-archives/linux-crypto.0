From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: Re: [PATCH 2/2] crypto: testmgr - make test_aead also test 'dst !=
 src' code paths
Date: Tue, 12 Nov 2013 23:54:15 +0200
Message-ID: <5282A387.1020200@iki.fi>
References: <20120921072647.11790.19493.stgit@localhost6.localdomain6> <20120921072652.11790.31387.stgit@localhost6.localdomain6> <52820CF9.3070406@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>
To: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56902 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756792Ab3KLVyW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Nov 2013 16:54:22 -0500
In-Reply-To: <52820CF9.3070406@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 12.11.2013 13:11, Horia Geant=C4=83 wrote:
> On 9/21/2012 10:26 AM, Jussi Kivilinna wrote:
>> Currrently test_aead uses same buffer for destination and source. Ho=
wever
>> in any places, 'dst !=3D src' take different path than 'dst =3D=3D s=
rc' case.
>>
>> Therefore make test_aead also run tests with destination buffer bein=
g
>> different than source buffer.
>>
>> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
>> ---
>>   crypto/testmgr.c |  153 +++++++++++++++++++++++++++++++++++++-----=
------------
>>   1 file changed, 105 insertions(+), 48 deletions(-)
>>
>> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
>> index 00f54d5..941d75c 100644
>> --- a/crypto/testmgr.c
>> +++ b/crypto/testmgr.c
>=20
>> @@ -442,18 +460,26 @@ static int test_aead(struct crypto_aead *tfm, =
int enc,
>>               authsize =3D abs(template[i].rlen - template[i].ilen);
>>               ret =3D crypto_aead_setauthsize(tfm, authsize);
>>               if (ret) {
>> -                printk(KERN_ERR "alg: aead: Failed to set "
>> -                       "authsize to %u on test %d for %s\n",
>> -                       authsize, j, algo);
>> +                pr_err("alg: aead%s: Failed to set authsize to %u o=
n test %d for %s\n",
>> +                       d, authsize, j, algo);
>>                   goto out;
>>               }
>>                 sg_init_one(&sg[0], input,
>>                       template[i].ilen + (enc ? authsize : 0));
>>   +            if (diff_dst) {
>> +                output =3D xoutbuf[0];
>> +                sg_init_one(&sgout[0], output,
>> +                        template[i].ilen +
>> +                        (enc ? authsize : 0));
>> +            } else {
>> +                output =3D input;
>> +            }
>=20
> In case of diff_dst (src !=3D dst), is there any assumption / convent=
ion regarding allocation length of req->src and req->dst - are they sup=
posed be equal, even if it's not needed?
> For example, in case of diff_dst && encryption, currently both req->s=
rc and req->dst have then length =3D template[i].ilen + authsize. Shoul=
dn't length of req->src be template[i].ilen, i.e. no space allocated fo=
r ICV?

You're right, in diff_dst case, sg and sgout could be different size. T=
hat's what I thought at first, and so I changed the above part to:

			if (diff_dst) {
				output =3D xoutbuf[0];
				output +=3D align_offset;
				sg_init_one(&sg[0], input, template[i].ilen);
				sg_init_one(&sgout[0], output,
					    template[i].rlen);
			} else {
				sg_init_one(&sg[0], input,
					    template[i].ilen +
						(enc ? authsize : 0));
				output =3D input;
			}

But this causes scatterwalk.c to throw BUG:

[   62.213960] ------------[ cut here ]------------
[   62.214031] kernel BUG at crypto/scatterwalk.c:37!
[   62.214065] invalid opcode: 0000 [#1] PREEMPT SMP=20
[   62.214101] Modules linked in: zlib seed rmd320 rmd256 rmd128 cts cc=
m ghash_generic gcm salsa20_generic salsa20_x86_64 fcrypt pcbc tgr192 a=
nubis wp512 khazad tea michael_mic arc4 cast6_generic seqiv md4 ecb tcr=
ypt(+) deflate ctr twofish_generic twofish_x86_64_3way twofish_x86_64 t=
wofish_common camellia_generic camellia_x86_64 serpent_sse2_x86_64 glue=
_helper lrw serpent_generic xts gf128mul blowfish_generic blowfish_x86_=
64 blowfish_common ablk_helper cryptd cast5_generic cast_common des_gen=
eric cbc cmac xcbc rmd160 sha512_ssse3 sha512_generic sha256_ssse3 sha2=
56_generic sha1_ssse3 sha1_generic md5 hmac crypto_null af_key xfrm_alg=
o dm_crypt dm_mod ppdev parport_pc ac ohci_pci ohci_hcd i2c_piix4 lp pa=
rport nfsd nfs_acl rpcsec_gss_krb5 auth_rpcgss oid_registry nfsv4 nfs l=
ockd sunrpc btrfs raid6_pq xor libcrc32c floppy intel_agp intel_gtt agp=
gart button ata_piix e1000
[   62.214603] CPU: 1 PID: 2131 Comm: cryptomgr_test Not tainted 3.11.0=
-cryptotest-jk1+ #59
[   62.214661] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS =
VirtualBox 12/01/2006
[   62.214720] task: ffff880037559c80 ti: ffff88003cb0c000 task.ti: fff=
f88003cb0c000
[   62.214776] RIP: 0010:[<ffffffff8122c730>]  [<ffffffff8122c730>] sca=
tterwalk_bytes_sglen+0x70/0x70
[   62.214847] RSP: 0018:ffff88003cb0dae0  EFLAGS: 00010246
[   62.214880] RAX: 00000000000000f2 RBX: ffff8800376964b0 RCX: 0000000=
000000000
[   62.214916] RDX: ffff880037694800 RSI: ffff880037694800 RDI: ffff880=
03cb0db18
[   62.214952] RBP: ffff880037696c00 R08: 00000000d0597ff0 R09: 0000000=
000000000
[   62.214989] R10: 000000006b5d5311 R11: 00000000d1bd7079 R12: ffff880=
037696c00
[   62.215389] R13: 0000000000000000 R14: 0000000000002000 R15: 0000000=
000000000
[   62.215730] FS:  0000000000000000(0000) GS:ffff88003fd00000(0000) kn=
lGS:0000000000000000
[   62.216411] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   62.216659] CR2: 00007f8d50b79420 CR3: 000000003c8b2000 CR4: 0000000=
0000006e0
[   62.217019] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
[   62.217247] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000=
000000400
[   62.217247] Stack:
[   62.217247]  ffffffff8122c758 ffffffffa0490418 ffff88003ca2a01e 0000=
00003db65000
[   62.217247]  ffff88003cb0dfd8 ffff88003cb0dfd8 ffff8800376964c0 ffff=
880037694800
[   62.217247]  000000d000000020 ffff8800376964b0 ffff880037696458 ffff=
880037696c00
[   62.217247] Call Trace:
[   62.217247]  [<ffffffff8122c758>] ? scatterwalk_start+0x18/0x20
[   62.217247]  [<ffffffffa0490418>] ? get_data_to_compute+0x28/0x2b0 [=
ccm]
[   62.217247]  [<ffffffffa04907c7>] ? crypto_ccm_auth+0x127/0x190 [ccm=
]
[   62.217247]  [<ffffffffa049119a>] ? crypto_ccm_encrypt+0x6a/0x275 [c=
cm]
[   62.217247]  [<ffffffff8126c3b4>] ? sg_init_table+0x14/0x30
[   62.217247]  [<ffffffff81233f46>] ? __test_aead+0x3f6/0xf60
[   62.217247]  [<ffffffff8122c4c8>] ? crypto_spawn_tfm+0x38/0x70
[   62.217247]  [<ffffffff81131717>] ? __kmalloc+0x1d7/0x200
[   62.217247]  [<ffffffff8122a5c9>] ? __crypto_alloc_tfm+0xe9/0x160
[   62.217247]  [<ffffffff81234af9>] ? test_aead+0x49/0xa0
[   62.217247]  [<ffffffff81234b8a>] ? alg_test_aead+0x3a/0x90
[   62.217247]  [<ffffffff81232e03>] ? alg_test+0xc3/0x290
[   62.217247]  [<ffffffff8106f130>] ? finish_task_switch+0x40/0xc0
[   62.217247]  [<ffffffff81536947>] ? __schedule+0x287/0x760
[   62.217247]  [<ffffffff81231b30>] ? crypto_unregister_pcomp+0x10/0x1=
0
[   62.217247]  [<ffffffff81231b68>] ? cryptomgr_test+0x38/0x40
[   62.217247]  [<ffffffff8106590f>] ? kthread+0xaf/0xc0
[   62.217247]  [<ffffffff81065860>] ? kthread_create_on_node+0x120/0x1=
20
[   62.217247]  [<ffffffff8153902c>] ? ret_from_fork+0x7c/0xb0
[   62.217247]  [<ffffffff81065860>] ? kthread_create_on_node+0x120/0x1=
20
[   62.217247] Code: ff ff ff ff 0f 1f 80 00 00 00 00 f3 c3 66 0f 1f 44=
 00 00 48 8b 7f 20 48 83 e7 fc 41 0f 94 c0 eb bb 66 2e 0f 1f 84 00 00 0=
0 00 00 <0f> 0b 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 48 89 37 44 8=
b=20
[   62.217247] RIP  [<ffffffff8122c730>] scatterwalk_bytes_sglen+0x70/0=
x70
[   62.217247]  RSP <ffff88003cb0dae0>
[   62.227458] ---[ end trace 338f2122cbee98de ]---
[   63.411157] ------------[ cut here ]------------


This should probably be fixed, right?

-Jussi

>=20
> Thanks,
> Horia
>=20
>=20
>=20
>=20
