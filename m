From: Sandra Schlichting <littlesandra88@gmail.com>
Subject: Re: Workaround for tcrypt bug?
Date: Fri, 28 Dec 2012 14:06:05 +0100
Message-ID: <CAELiMBNaV8mS=R2O6N0eK1sm5528XMC8ex=QAjeecaJ+8KEJXg@mail.gmail.com>
References: <CAELiMBOPsPOWNe6+LahiBqGteucai0xrqY+eQ0nxkghjAEsy-A@mail.gmail.com>
 <CAELiMBOtmQwY8kH=nLTZzjPtNqPsC_GGgs=gDe7pQwFewsxY1A@mail.gmail.com>
 <20121228141825.11102bkeriixmuqs@www.dalek.fi> <CAELiMBMrmagP14SoE1aaDqnuXvwdtVM69zpmK5dn+9Zqby8sQw@mail.gmail.com>
 <20121228145509.16824jqi8bl9komo@www.dalek.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-crypto@vger.kernel.org
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qa0-f43.google.com ([209.85.216.43]:51563 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536Ab2L1NGq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 28 Dec 2012 08:06:46 -0500
Received: by mail-qa0-f43.google.com with SMTP id cr7so9521948qab.2
        for <linux-crypto@vger.kernel.org>; Fri, 28 Dec 2012 05:06:45 -0800 (PST)
In-Reply-To: <20121228145509.16824jqi8bl9komo@www.dalek.fi>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> I think you are using wrong module argument, type= instead of mode=. Try
> 'modprobe tcrypt sec=2 mode=402' instead.

Thanks. I would never have thought of that =)

Now it preforms the test, but gives this interesting error:

[root@amd ~]# modprobe tcrypt sec=2 mode=402

Message from syslogd@amd at Dec 28 14:01:05 ...
 kernel:[ 5508.698788] BUG: soft lockup - CPU#0 stuck for 22s! [modprobe:3416]
ERROR: could not insert 'tcrypt': Resource temporarily unavailable

and dmesg gives

[ 5483.730759]
[ 5483.730759] testing speed of async md5
[ 5483.730808] test  0 (   16 byte blocks,   16 bytes per update,   1
updates): 1321110 opers/sec,  21137768 bytes/sec
[ 5485.729538] test  1 (   64 byte blocks,   16 bytes per update,   4
updates): 580970 opers/sec,  37182112 bytes/sec
[ 5487.728254] test  2 (   64 byte blocks,   64 bytes per update,   1
updates): 779323 opers/sec,  49876672 bytes/sec
[ 5489.726972] test  3 (  256 byte blocks,   16 bytes per update,  16
updates): 200928 opers/sec,  51437568 bytes/sec
[ 5491.725692] test  4 (  256 byte blocks,   64 bytes per update,   4
updates): 304514 opers/sec,  77955712 bytes/sec
[ 5493.724408] test  5 (  256 byte blocks,  256 bytes per update,   1
updates): 365982 opers/sec,  93691392 bytes/sec
[ 5495.723126] test  6 ( 1024 byte blocks,   16 bytes per update,  64
updates):  55802 opers/sec,  57141248 bytes/sec
[ 5497.721848] test  7 ( 1024 byte blocks,  256 bytes per update,   4
updates): 110900 opers/sec, 113562112 bytes/sec
[ 5499.720564] test  8 ( 1024 byte blocks, 1024 bytes per update,   1
updates): 118861 opers/sec, 121713664 bytes/sec
[ 5501.719281] test  9 ( 2048 byte blocks,   16 bytes per update, 128
updates):  28424 opers/sec,  58212352 bytes/sec
[ 5503.718022] test 10 ( 2048 byte blocks,  256 bytes per update,   8
updates):  57602 opers/sec, 117968896 bytes/sec
[ 5505.716727] test 11 ( 2048 byte blocks, 1024 bytes per update,   2
updates):  61696 opers/sec, 126353408 bytes/sec
[ 5507.715435] test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates):
[ 5508.698788] BUG: soft lockup - CPU#0 stuck for 22s! [modprobe:3416]
[ 5508.698793] Modules linked in: tcrypt(+) ansi_cprng vmac xcbc zlib
seed rmd320 rmd256 rmd160 rmd128 cts ccm lzo ghash_generic gcm
salsa20_generic salsa20_x86_64 camellia_generic camellia_x86_64 fcrypt
pcbc tgr192 anubis wp512 khazad tea michael_mic arc4 cast6 cast5
deflate zlib_deflate sha512_generic serpent_sse2_x86_64
serpent_generic twofish_generic twofish_x86_64_3way xts lrw gf128mul
glue_helper twofish_x86_64 twofish_common blowfish_generic
blowfish_x86_64 blowfish_common md4 des_generic fuse ip6table_filter
ip6_tables ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat
xt_CHECKSUM iptable_mangle lockd sunrpc bridge stp llc be2iscsi
iscsi_boot_sysfs bnx2i cnic uio cxgb4i cxgb4 cxgb3i cxgb3 mdio
libcxgbi ib_iser rdma_cm ib_addr iw_cm ib_cm ib_sa ib_mad ib_core
iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi nf_conntrack_ipv4
nf_defrag_ipv4 xt_state nf_conntrack dm_crypt btusb eeepc_wmi asus_wmi
sparse_keymap video ath3k bluetooth rfkill microcode serio_raw r8169
mii k10temp i2c_piix4 snd_hda_codec_realtek snd_hda_codec_hdmi
snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm
snd_page_alloc snd_timer snd soundcore binfmt_misc vhost_net tun
macvtap macvlan kvm_amd kvm uinput ata_generic pata_acpi pata_atiixp
wmi radeon i2c_algo_bit drm_kms_helper ttm drm i2c_core
[ 5508.698961] CPU 0
[ 5508.698970] Pid: 3416, comm: modprobe Not tainted
3.6.10-2.fc17.x86_64 #1 System manufacturer System Product
Name/F1A75-I DELUXE
[ 5508.698975] RIP: 0010:[<ffffffff812ddffb>]  [<ffffffff812ddffb>]
md5_transform+0x4db/0x800
[ 5508.698991] RSP: 0018:ffff8801fb401a80  EFLAGS: 00000293
[ 5508.698995] RAX: 000000000c00583a RBX: 000000ff812e5114 RCX: 00000000ffffffff
[ 5508.698999] RDX: 00000000a636da5e RSI: 00000000ffffffff RDI: ffff880210c6c8a0
[ 5508.699002] RBP: ffff8801fb401ad8 R08: 00000000ffffffff R09: 00000000ffffffff
[ 5508.699006] R10: 00000000ffffffff R11: 00000000ffffffff R12: ffffffff81e77e0a
[ 5508.699009] R13: ffffffff00000006 R14: ffff8801fb401a0e R15: ffffffffffffffff
[ 5508.699015] FS:  00007ff4d87f7740(0000) GS:ffff88021ec00000(0000)
knlGS:0000000000000000
[ 5508.699019] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 5508.699022] CR2: 00007ff4d86b3000 CR3: 00000001b4911000 CR4: 00000000000007f0
[ 5508.699027] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 5508.699031] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 5508.699036] Process modprobe (pid: 3416, threadinfo
ffff8801fb400000, task ffff880213979710)
[ 5508.699038] Stack:
[ 5508.699041]  3e4ebf9e98282ef4 33626d4a33683409 ffffffffffffffff
ffffffffffffffff
[ 5508.699048]  ffffffffffffffff ffffffffffffffff ffff8801c495f7c0
ffff880210c6c8a0
[ 5508.699055]  ffff880210c6c8b0 0000000000000040 ffff880210c6c8b0
ffff8801fb401b38
[ 5508.699061] Call Trace:
[ 5508.699073]  [<ffffffff812abc39>] md5_update+0xe9/0x140
[ 5508.699081]  [<ffffffff812a6df5>] crypto_shash_update+0x45/0x120
[ 5508.699088]  [<ffffffff812a6ceb>] ? crypto_shash_final+0x3b/0xc0
[ 5508.699095]  [<ffffffff812a6f50>] shash_finup_unaligned+0x20/0x40
[ 5508.699102]  [<ffffffff812a6f8f>] crypto_shash_finup+0x1f/0x40
[ 5508.699108]  [<ffffffff812a6ff8>] shash_digest_unaligned+0x48/0x60
[ 5508.699115]  [<ffffffff812a72b0>] ? shash_ahash_digest+0xf0/0xf0
[ 5508.699121]  [<ffffffff812a702f>] crypto_shash_digest+0x1f/0x40
[ 5508.699128]  [<ffffffff812a727e>] shash_ahash_digest+0xbe/0xf0
[ 5508.699134]  [<ffffffff812a72b0>] ? shash_ahash_digest+0xf0/0xf0
[ 5508.699141]  [<ffffffff812a72d4>] shash_async_digest+0x24/0x30
[ 5508.699147]  [<ffffffff812a6465>] crypto_ahash_op+0x35/0xe0
[ 5508.699153]  [<ffffffff812a6526>] crypto_ahash_digest+0x16/0x20
[ 5508.699164]  [<ffffffffa0701e89>]
test_ahash_speed.constprop.7+0x659/0x7b0 [tcrypt]
[ 5508.699172]  [<ffffffff810b9acc>] ? smp_call_function_many+0x22c/0x260
[ 5508.699185]  [<ffffffffa015b000>] ? 0xffffffffa015afff
[ 5508.699195]  [<ffffffffa0702061>] do_test+0x81/0x2404 [tcrypt]
[ 5508.699205]  [<ffffffffa015b000>] ? 0xffffffffa015afff
[ 5508.699214]  [<ffffffffa015b06e>] tcrypt_mod_init+0x6e/0x1000 [tcrypt]
[ 5508.699224]  [<ffffffffa015b000>] ? 0xffffffffa015afff
[ 5508.699233]  [<ffffffff8100212a>] do_one_initcall+0x12a/0x180
[ 5508.699242]  [<ffffffff810bf16e>] sys_init_module+0xfbe/0x20c0
[ 5508.699248]  [<ffffffff812f9220>] ? ddebug_proc_open+0xd0/0xd0
[ 5508.699257]  [<ffffffff816270e9>] system_call_fastpath+0x16/0x1b
[ 5508.699260] Code: ec 44 8b 6d d4 41 c1 c4 17 41 01 c4 47 8d b4 35
44 ea be a4 41 89 c5 41 31 d5 45 31 e5 45 01 f5 44 8b 75 c8 41 c1 c5
04 45 01 e5 <41> 8d 94 16 a9 cf de 4b 45 8d b4 03 60 4b bb f6 89 55 b4
44 89
[ 5509.714149]  62666 opers/sec, 128339968 bytes/sec
[ 5509.714153] test 13 ( 4096 byte blocks,   16 bytes per update, 256
updates):  14349 opers/sec,  58773504 bytes/sec
[ 5511.712900] test 14 ( 4096 byte blocks,  256 bytes per update,  16
updates):  29364 opers/sec, 120274944 bytes/sec
[ 5513.711616] test 15 ( 4096 byte blocks, 1024 bytes per update,   4
updates):  31516 opers/sec, 129089536 bytes/sec
[ 5515.710331] test 16 ( 4096 byte blocks, 4096 bytes per update,   1
updates):  32178 opers/sec, 131803136 bytes/sec
[ 5517.709019] test 17 ( 8192 byte blocks,   16 bytes per update, 512
updates):   7208 opers/sec,  59047936 bytes/sec
[ 5519.707805] test 18 ( 8192 byte blocks,  256 bytes per update,  32
updates):  14826 opers/sec, 121458688 bytes/sec
[ 5521.706479] test 19 ( 8192 byte blocks, 1024 bytes per update,   8
updates):  15924 opers/sec, 130449408 bytes/sec
[ 5523.705188] test 20 ( 8192 byte blocks, 4096 bytes per update,   2
updates):  16264 opers/sec, 133234688 bytes/sec
[ 5525.703944] test 21 ( 8192 byte blocks, 8192 bytes per update,   1
updates):  16262 opers/sec, 133218304 bytes/sec
[root@amd maj]#
