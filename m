From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: rng_dev_read: Kernel memory exposure attempt detected from SLUB
 object 'kmalloc-64'
Date: Mon, 10 Sep 2018 22:02:38 +0200
Message-ID: <CAKv+Gu-GUdYgy=cJnD5-HB3c2vxv53YbzY10CATocqP2DQrAwg@mail.gmail.com>
References: <alpine.LRH.2.21.1809102006280.8926@math.ut.ee> <20180910195342.GD16557@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: "Theodore Y. Ts'o" <tytso@mit.edu>, Meelis Roos <mroos@linux.ee>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180910195342.GD16557@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

n

On 10 September 2018 at 21:53, Theodore Y. Ts'o <tytso@mit.edu> wrote:
> On Mon, Sep 10, 2018 at 08:08:51PM +0300, Meelis Roos wrote:
>> This is weekend's 4.19.0-rc2-00246-gd7b686ebf704 on a Thinkad T460s.
>> There seems to be a usercopy warning from rng_dev read (full dmesg
>> below).
>
> Looking at rng_dev_head(), which is in drivers/char/hw_random.c, it
> looks like this was probably caused by a problem in the specific
> hardware random number generator being used.  Can you tell us which
> one was in use?
>

The line right before the splat suggests that this is tpm_get_random()
in drivers/char/tpm/tpm-interface.c

[...]

>> [146535.257274] tpm tpm0: A TPM error (379) occurred attempting get rand=
om
>> [146535.257304] usercopy: Kernel memory exposure attempt detected from S=
LUB object 'kmalloc-64' (offset 0, size 379)!

The TPM return code '379' is returned from rng_get_data(), and
interpreted as a byte count rather than an error code.


>> [146535.257331] ------------[ cut here ]------------
>> [146535.257338] kernel BUG at mm/usercopy.c:102!
>> [146535.257361] invalid opcode: 0000 [#1] SMP PTI
>> [146535.257375] CPU: 0 PID: 1729 Comm: rngd Not tainted 4.19.0-rc2-00246=
-gd7b686ebf704 #36
>> [146535.257382] Hardware name: LENOVO 20F9003SMS/20F9003SMS, BIOS N1CET6=
5W (1.33 ) 02/16/2018
>> [146535.257402] RIP: 0010:usercopy_abort+0x6f/0x71
>> [146535.257412] Code: 0f 45 c6 48 c7 c2 b4 26 80 a4 48 c7 c6 b5 53 7f a4=
 51 48 0f 45 f2 48 89 f9 41 52 48 89 c2 48 c7 c7 80 27 80 a4 e8 7e 3a ed ff=
 <0f> 0b 49 89 e8 31 c9 44 89 e2 31 f6 48 c7 c7 e8 26 80 a4 e8 79 ff
>> [146535.257421] RSP: 0018:ffffbc4ec076bdb0 EFLAGS: 00010246
>> [146535.257433] RAX: 0000000000000065 RBX: ffff9c2d1464ad80 RCX: 0000000=
000000006
>> [146535.257441] RDX: 0000000000000000 RSI: 0000000000000086 RDI: ffff9c2=
d16a15500
>> [146535.257449] RBP: 000000000000017b R08: ffffffffa3f11900 R09: 0000000=
000000065
>> [146535.257457] R10: ffffffffa50908d8 R11: ffffffffa507efae R12: 0000000=
000000001
>> [146535.257463] R13: ffff9c2d1464aefb R14: 000000000000017b R15: 0000000=
00000017b
>> [146535.257474] FS:  00007f023c524700(0000) GS:ffff9c2d16a00000(0000) kn=
lGS:0000000000000000
>> [146535.257484] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [146535.257492] CR2: 00001834aa0fc000 CR3: 0000000309104005 CR4: 0000000=
0003606f0
>> [146535.257499] Call Trace:
>> [146535.257524]  __check_heap_object+0xd5/0x100
>> [146535.257539]  __check_object_size+0xf5/0x17c
>> [146535.257554]  rng_dev_read+0x6e/0x270
>> [146535.257576]  __vfs_read+0x31/0x170
>> [146535.257604]  vfs_read+0x85/0x130
>> [146535.257631]  ksys_read+0x4a/0xb0
>> [146535.257658]  do_syscall_64+0x4a/0xf0
>> [146535.257695]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>> [146535.257716] RIP: 0033:0x7f023c6f6394
>> [146535.257735] Code: 84 00 00 00 00 00 41 54 55 49 89 d4 53 48 89 f5 89=
 fb 48 83 ec 10 e8 8b fc ff ff 4c 89 e2 41 89 c0 48 89 ee 89 df 31 c0 0f 05=
 <48> 3d 00 f0 ff ff 77 38 44 89 c7 48 89 44 24 08 e8 c7 fc ff ff 48
>> [146535.257748] RSP: 002b:00007f023c523e10 EFLAGS: 00000246 ORIG_RAX: 00=
00000000000000
>> [146535.257767] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f0=
23c6f6394
>> [146535.257776] RDX: 00000000000009c4 RSI: 0000563938a24f00 RDI: 0000000=
000000003
>> [146535.257790] RBP: 0000563938a24f00 R08: 0000000000000000 R09: 00007ff=
f1df64080
>> [146535.257803] R10: 0000000000000001 R11: 0000000000000246 R12: 0000000=
0000009c4
>> [146535.257816] R13: 00007fff1dedba3f R14: 00007fff1dedba40 R15: 0000000=
000000000
>> [146535.257836] Modules linked in: ipheth tun ipt_MASQUERADE nf_conntrac=
k_netlink iptable_nat nf_nat_ipv4 xt_addrtype iptable_filter bpfilter xt_co=
nntrack nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 libcrc32c br_netf=
ilter bridge stp llc overlay fuse bnep cpufreq_userspace snd_hda_codec_hdmi=
 iwlmvm mac80211 uvcvideo snd_hda_codec_realtek videobuf2_vmalloc cdc_mbim =
iwlwifi x86_pkg_temp_thermal videobuf2_memops snd_hda_codec_generic intel_p=
owerclamp cdc_wdm videobuf2_v4l2 coretemp videobuf2_common joydev pcspkr cd=
c_ncm btusb snd_hda_intel iTCO_wdt btrtl iTCO_vendor_support btbcm snd_hda_=
codec videodev snd_hwdep media usbnet btintel snd_hda_core mii cdc_acm cfg8=
0211 bluetooth ecdh_generic mei_me mei intel_pch_thermal tpm_crb tpm_tis tp=
m_tis_core thinkpad_acpi tpm pcc_cpufreq ip_tables dm_crypt dm_mod
>> [146535.258082]  dax hid_generic rtsx_pci_sdmmc mmc_core crct10dif_pclmu=
l e1000e i2c_i801 rtsx_pci mfd_core
>> [146535.258139] ---[ end trace 40fa61fde8e22944 ]---
>> [146535.258260] RIP: 0010:usercopy_abort+0x6f/0x71
>> [146535.258290] Code: 0f 45 c6 48 c7 c2 b4 26 80 a4 48 c7 c6 b5 53 7f a4=
 51 48 0f 45 f2 48 89 f9 41 52 48 89 c2 48 c7 c7 80 27 80 a4 e8 7e 3a ed ff=
 <0f> 0b 49 89 e8 31 c9 44 89 e2 31 f6 48 c7 c7 e8 26 80 a4 e8 79 ff
>> [146535.258315] RSP: 0018:ffffbc4ec076bdb0 EFLAGS: 00010246
>> [146535.258367] RAX: 0000000000000065 RBX: ffff9c2d1464ad80 RCX: 0000000=
000000006
>> [146535.258391] RDX: 0000000000000000 RSI: 0000000000000086 RDI: ffff9c2=
d16a15500
>> [146535.258421] RBP: 000000000000017b R08: ffffffffa3f11900 R09: 0000000=
000000065
>> [146535.258450] R10: ffffffffa50908d8 R11: ffffffffa507efae R12: 0000000=
000000001
>> [146535.258485] R13: ffff9c2d1464aefb R14: 000000000000017b R15: 0000000=
00000017b
>> [146535.258520] FS:  00007f023c524700(0000) GS:ffff9c2d16a00000(0000) kn=
lGS:0000000000000000
>> [146535.258555] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [146535.258593] CR2: 00001834aa0fc000 CR3: 0000000309104005 CR4: 0000000=
0003606f0
>>
>> --
>> Meelis Roos (mroos@linux.ee)
