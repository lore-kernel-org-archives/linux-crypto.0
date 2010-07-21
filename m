From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Subject: using hmac-sha256 to generate smb2 signagures and oopsing
Date: Wed, 21 Jul 2010 11:57:41 -0500
Message-ID: <AANLkTinKylPNB30mmYbCr41s4qCJVbzerPSKxGveelBu@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Steve French <smfrench@gmail.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:62608 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab0GUQ5n (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 Jul 2010 12:57:43 -0400
Received: by qyk38 with SMTP id 38so3248258qyk.19
        for <linux-crypto@vger.kernel.org>; Wed, 21 Jul 2010 09:57:42 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Not sure the oops, wondering what am I doing incorrect while invoking
ahash_request_set_crypt with an array of scatterlist and then calling
ahash_crypto_digest.

Just to experiment, I called ahash_request_set_crypt with a single
scatterlist and I did not oops.

Any help/pointers are appreciated.

Regards,

Shirish

--------------------------------------------------------------------------------------------------------------

BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<ffffffff8118aaa9>] hash_walk_new_entry+0x8/0x36
PGD 13522a067 PUD 135001067 PMD 0
Oops: 0000 [#1] SMP
last sysfs file: /sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
CPU 1
Modules linked in: smb2_fs sha256_generic arc4 ecb nls_utf8 ipv6 mperf
microcode
                               fuse loop dm_mod ibmpex rtc_cmos bnx2
ibmaem rtc_core iTCO_wdt i5k_amb iTCO_ven

dor_support i2c_i801 shpchp ses i5000_edac ipmi_msghandler ioatdma
rtc_lib pcspk
                                  r button joydev enclosure edac_core
i2c_core sr_mod tpm_tis pci_hotplug cdrom tp
                                                                 m
tpm_bios dca sg usbhid hid uhci_hcd ehci_hcd usbcore sd_mod crc_t10dif
edd ext
                            3 mbcache jbd fan ide_pci_generic piix
ide_core ata_generic ata_piix libata ther
                                                              mal
processor thermal_sys hwmon aacraid scsi_mod [last unloaded: smb2_fs]

Pid: 3919, comm: mount Not tainted 2.6.34-1-default-1 #3 System
Planar/IBM Syste
                                     m x3550 -[7978AC1]-
RIP: 0010:[<ffffffff8118aaa9>]  [<ffffffff8118aaa9>]
hash_walk_new_entry+0x8/0x3
                                                6
RSP: 0018:ffff88013448b938  EFLAGS: 00010202
RAX: 0000000000000000 RBX: ffff88013448b978 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88013448b978
RBP: ffff88013448b938 R08: 00000000a0dd3789 R09: 00000000ba94fc5a
R10: 000000008de460b5 R11: 00000000f51f557b R12: 0000000000000000
R13: 0000000000000000 R14: ffff880135ee4750 R15: ffff88013448bc58
FS:  00007f60de2f6780(0000) GS:ffff880006280000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 00000001344f8000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process mount (pid: 3919, threadinfo ffff88013448a000, task ffff880135200440)
Stack:
 ffff88013448b968 ffffffff8118b1d0 ffff88013448b958 ffff88013448b978
<0> ffff880135ee4700 ffff880135ee4750 ffff88013448b9c8 ffffffff8118bb53
<0> ffff88013977c000 0000000000000db4 ffffea0004492320 0000003000000000
Call Trace:
 [<ffffffff8118b1d0>] crypto_hash_walk_done+0xcf/0xdf
 [<ffffffff8118bb53>] shash_ahash_finup+0x63/0x76
 [<ffffffff8118bc5f>] shash_ahash_digest+0xd8/0xe7
 [<ffffffff8118bc6e>] ? shash_async_digest+0x0/0x21
 [<ffffffff8118bc8d>] shash_async_digest+0x1f/0x21
 [<ffffffff8118aee2>] crypto_ahash_op+0xac/0xbb
 [<ffffffff8118af02>] crypto_ahash_digest+0x11/0x13
 [<ffffffffa02fd14b>] smb2_calc_signature2+0x27c/0x2d9 [smb2_fs]
 [<ffffffff8118649d>] ? crypto_alloc_tfm+0x50/0x8e
 [<ffffffffa02fd252>] sign_smb2+0x93/0xb3 [smb2_fs]
 [<ffffffffa0301c08>] smb2_sendrcv2+0x10c/0x44c [smb2_fs]
 [<ffffffffa03011cc>] ? smb2_strndup_to_ucs+0x5c/0x74 [smb2_fs]
 [<ffffffffa02fe345>] SMB2_tcon+0x11b/0x1f3 [smb2_fs]
 [<ffffffff810f14aa>] ? __kmalloc_track_caller+0x220/0x28a
 [<ffffffffa02f1869>] smb2_mount+0x1685/0x18fe [smb2_fs]
 [<ffffffff810ee8be>] ? cache_alloc_debugcheck_after+0x30/0x19d
 [<ffffffffa02f002c>] ? smb2_get_tcp_session+0x522/0x570 [smb2_fs]
 [<ffffffffa02fda1b>] smb2_get_sb+0x18e/0x4d6 [smb2_fs]
 [<ffffffff810ec3f7>] ? alloc_pages_current+0x96/0x9f
 [<ffffffff810fd7c3>] vfs_kern_mount+0xad/0x188
 [<ffffffff810fd8fb>] do_kern_mount+0x47/0xe7
 [<ffffffff81113763>] do_mount+0x783/0x7fc
 [<ffffffff81111a08>] ? copy_mount_options+0xd2/0x134
 [<ffffffff8111385b>] sys_mount+0x7f/0xb8
 [<ffffffff81002d42>] system_call_fastpath+0x16/0x1b
Code: 85 f1 48 89 07 75 10 b8 00 10 00 00 29 c8 44 39 c0 41 0f 47 c0
eb 07 f7 d1
                                 21 f1 8d 41 01 29 47 18 c9 c3 48 8b
57 20 55 48 89 e5 <48> 8b 02 48 83 e0 fc 48
                                                                 89 47
10 8b 42 08 89 47 08 8b 42 0c 8b
RIP  [<ffffffff8118aaa9>] hash_walk_new_entry+0x8/0x36
 RSP <ffff88013448b938>
CR2: 0000000000000000
---[ end trace 20511fa65a698da8 ]---


int sign_smb2(struct kvec *iov, int n_vec, struct tcp_srv_inf *server)
{
        int rc = 0;
        struct smb2_hdr *smb2_pdu = iov[0].iov_base;

        if ((smb2_pdu == NULL) || (server == NULL))
                return -EINVAL;

        if ((smb2_pdu->Flags & SMB2_FLAGS_SIGNED) == 0)
                return rc;

        server->hmacsha256 =
                crypto_alloc_ahash("hmac(sha256)", 0, CRYPTO_ALG_ASYNC);
        if (!server->hmacsha256 || IS_ERR(server->hmacsha256)) {
                sERROR(1, "could not allocate master crypto API hmacsha256\n");
                return 1;
        }

        rc = smb2_calc_signature2(iov, n_vec, server, smb2_pdu);

        crypto_free_ahash(server->hmacsha256);

        return rc;
}


static int smb2_calc_signature2(const struct kvec *iov, int n_vec,
                struct tcp_srv_inf *server, struct smb2_hdr *smb2_pdu)
{
        int i;
        int rc;
        unsigned int tlen = 0;
        unsigned char smb2_signature[64];
        struct scatterlist sgin[n_vec];
        unsigned char *sigptr = smb2_signature;
        struct ahash_request *req;
        struct hmac_sha256_result tresult;

        if ((iov == NULL) || (server == NULL))
                return -EINVAL;

        memset(smb2_signature, 0x0, 64);
        memset(smb2_pdu->Signature, 0x0, 16);
        sg_init_table(sgin, n_vec);

        req = ahash_request_alloc(server->hmacsha256, GFP_KERNEL);
        if (!req) {
                sERROR(1, "Failed to allocate request for hmac sha256\n");
                return 1;
        }
        ahash_request_set_callback(req, 0, hmac_sha256_complete, &tresult);

        for (i = 0; i < n_vec; i++) {
                if (iov[i].iov_len == 0)
                        continue;
                if (iov[i].iov_base == NULL) {
                        sERROR(1, "null iovec entry");
                        return -EIO;
                }
                /* The first entry includes a length field (which does not get
                   signed that occupies the first 4 bytes before the header */
                if (i == 0) {
                        if (iov[0].iov_len <= 8) /* cmd field at offset 9 */
                                break; /* nothing to sign or corrupt header */
                        sg_init_one(&sgin[i], iov[0].iov_base + 4,
                                        iov[0].iov_len - 4);
                        tlen += iov[0].iov_len - 4;
                } else {
                        sg_init_one(&sgin[i], iov[i].iov_base,
                                        iov[i].iov_len);
                        tlen += iov[i].iov_len;
                }
        }

        if (crypto_ahash_digestsize(server->hmacsha256) > tlen) {
                sERROR(1, "hmacsha256: tfm size > result buffer.\n");
                return -EINVAL;
        }

        crypto_ahash_clear_flags(server->hmacsha256, -0);
        rc = crypto_ahash_setkey(server->hmacsha256, server->sec_key, 16);
        if (rc) {
                sERROR(1, "Failed to set key for hmac sha256\n");
                return 1;
        }

        ahash_request_set_crypt(req, sgin, sigptr, tlen);
        rc = crypto_ahash_digest(req);

        memcpy(smb2_pdu->Signature, sigptr, 16);

        return rc;
}
