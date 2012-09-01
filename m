From: Romain Francoise <romain@orebokech.com>
Subject: v3.6-rc4: aead selftest fails with BUG
Date: Sat, 01 Sep 2012 22:37:04 +0200
Message-ID: <878vct1nv3.fsf@silenus.orebokech.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stringer.orebokech.com ([88.190.240.207]:57305 "EHLO
	stringer.orebokech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191Ab2IAUnW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 1 Sep 2012 16:43:22 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I get the following BUG when setting up an IPsec SA. The aead combination
under test when that happens is authenc(hmac(sha1-ssse3),cbc-aes-aesni),
it remains in 'selftest: unknown' status in /proc/crypto.

Thanks,

------------[ cut here ]------------
kernel BUG at crypto/scatterwalk.c:37!
invalid opcode: 0000 [#1] SMP 
Modules linked in: authenc xfrm6_mode_tunnel xfrm4_mode_tunnel cpufreq_conservative cpufreq_userspace cpufreq_powersave cpufreq_stats xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 binfmt_misc deflate zlib_deflate ctr twofish_generic twofish_avx_x86_64 twofish_x86_64_3way twofish_x86_64 twofish_common camellia_generic camellia_x86_64 serpent_avx_x86_64 serpent_sse2_x86_64 serpent_generic glue_helper lrw xts gf128mul blowfish_generic blowfish_x86_64 blowfish_common cast5 des_generic cbc xcbc rmd160 sha512_generic sha1_ssse3 sha1_generic hmac crypto_null af_key xfrm_algo ip6table_filter ip6_tables xt_recent xt_LOG nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_tcpudp iptable_filter ip_tables x_tables hwmon_vid msr vhost_net macvtap macvlan tun loop bridge stp llc firew
 ire_sbp2 fuse snd_hda_codec_hdmi rc_dib0700_rc5 snd_hda_codec_realtek dvb_usb_dib0700 snd_hda_intel dib7000m dib0090 dib8000 dib0070 dib7000p snd_hda_codec snd_hwdep dib3000mc dibx0
n dvb_usb snd_pcm_oss snd_mixer_oss snd_pcm dvb_core snd_seq_midi snd_seq_midi_event rc_core snd_rawmidi ttm snd_seq drm_kms_helper drm psmouse snd_seq_device i2c_i801 serio_raw pcspkr i2c_algo_bit i2c_core mei mxm_wmi evdev coretemp snd_timer lpc_ich acpi_cpufreq mperf snd soundcore processor snd_page_alloc thermal_sys kvm_intel kvm wmi button ext4 crc16 jbd2 mbcache sha256_generic usb_storage uas dm_crypt dm_mod raid10 raid1 md_mod sg ata_generic hid_generic sd_mod crc_t10dif pata_marvell usbhid hid crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 aes_generic ablk_helper cryptd ahci libahci microcode libata firewire_ohci firewire_core crc_itu_t scsi_mod xhci_hcd ehci_hcd usbcore e1000e usb_common
CPU 1 
Pid: 3720, comm: cryptomgr_test Not tainted 3.6.0-rc4-ore #1                  /DP67BG
RIP: 0010:[<ffffffff811d70e1>]  [<ffffffff811d70e1>] scatterwalk_start+0x11/0x20
RSP: 0018:ffff88040ccff9d8  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88040b417068 RCX: 0000000000000014
RDX: 0000000000000020 RSI: ffff88040b417068 RDI: ffff88040ccff9e0
RBP: 0000000000000020 R08: 0000000000000001 R09: ffff88040b4171a8
R10: ffffffffa06b7000 R11: ffff88040b4171fc R12: 0000000000000014
R13: 0000000000000001 R14: ffff88040b4170f8 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88041f440000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f8d338cc010 CR3: 000000000180b000 CR4: 00000000000407e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process cryptomgr_test (pid: 3720, threadinfo ffff88040ccfe000, task ffff88040d852340)
Stack:
 ffffffff811d730b ffff88040b417068 0000002000000000 ffff88040b417068
 ffff88040b417000 ffff88040b417068 0000000000000020 ffff88040b417068
 ffff88040d6170c0 ffff88040ccffcc8 ffffffffa07efaa0 ffff88040b417130
Call Trace:
 [<ffffffff811d730b>] ? scatterwalk_map_and_copy+0x5b/0xd0
 [<ffffffffa07efaa0>] ? crypto_authenc_genicv+0xa0/0x300 [authenc]
 [<ffffffff811de5cb>] ? test_aead+0x58b/0xcd0
 [<ffffffff811d4cc0>] ? crypto_mod_get+0x10/0x30
 [<ffffffffa0110000>] ? _encrypt_by_4_encrypt+0x11/0x3a7 [aesni_intel]
 [<ffffffff811d57d3>] ? crypto_alloc_base+0x53/0xb0
 [<ffffffff8113ec29>] ? cache_alloc_refill+0x99/0x2c0
 [<ffffffffa01da6e0>] ? cryptd_alloc_ablkcipher+0x80/0xc0 [cryptd]
 [<ffffffff8113f40d>] ? __kmalloc+0x20d/0x250
 [<ffffffffa00e7050>] ? ablk_init_common+0x10/0x30 [ablk_helper]
 [<ffffffff811d5709>] ? __crypto_alloc_tfm+0xf9/0x170
 [<ffffffff811d63b3>] ? crypto_spawn_tfm+0x43/0x90
 [<ffffffff811d999e>] ? skcipher_geniv_init+0x1e/0x40
 [<ffffffff811d5709>] ? __crypto_alloc_tfm+0xf9/0x170
 [<ffffffff811d63b3>] ? crypto_spawn_tfm+0x43/0x90
 [<ffffffff8113f40d>] ? __kmalloc+0x20d/0x250
 [<ffffffffa07ef359>] ? crypto_authenc_init_tfm+0x49/0xc0 [authenc]
 [<ffffffff811d5709>] ? __crypto_alloc_tfm+0xf9/0x170
 [<ffffffff811dede8>] ? alg_test_aead+0x48/0xb0
 [<ffffffff811dddfe>] ? alg_test+0xfe/0x310
 [<ffffffff8141dbca>] ? __schedule+0x2ba/0x700
 [<ffffffff811dcb40>] ? cryptomgr_probe+0xb0/0xb0
 [<ffffffff811dcb78>] ? cryptomgr_test+0x38/0x40
 [<ffffffff8106fbb5>] ? kthread+0x85/0x90
 [<ffffffff81427b04>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff8106fb30>] ? kthread_freezable_should_stop+0x60/0x60
 [<ffffffff81427b00>] ? gs_change+0x13/0x13
Code: 00 00 88 ff ff 48 c1 e0 0c 48 01 d0 8b 57 08 81 e2 ff 0f 00 00 48 01 d0 c3 90 48 89 37 8b 46 0c 85 c0 74 07 8b 46 08 89 47 08 c3 <0f> 0b 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 8b 47 08 48 8b 17 
RIP  [<ffffffff811d70e1>] scatterwalk_start+0x11/0x20
 RSP <ffff88040ccff9d8>
---[ end trace b300e583cf57b188 ]---
note: cryptomgr_test[3720] exited with preempt_count 1
