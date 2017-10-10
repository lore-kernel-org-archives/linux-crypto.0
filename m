From: Romain Izard <romain.izard.pro@gmail.com>
Subject: Re: [PATCH] crypto: atmel-aes - properly set IV after {en,de}crypt
Date: Tue, 10 Oct 2017 15:18:07 +0200
Message-ID: <CAGkQfmNLAtMjDR_PrP=UPQ3cAPBDQt7yNa4cpX6ZeZfziXnikg@mail.gmail.com>
References: <20171006155108.6581-1-romain.izard.pro@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: David Gstir <david@sigma-star.at>,
        Nicolas Feignon <nicolas.feignon@mobile-devices.fr>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Cyrille Pitchen <cyrille.pitchen@microchip.com>,
        linux-crypto@vger.kernel.org,
        linux-mtd <linux-mtd@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Romain Izard <romain.izard.pro@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171006155108.6581-1-romain.izard.pro@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

2017-10-06 17:51 GMT+02:00 Romain Izard <romain.izard.pro@gmail.com>:
>
> Certain cipher modes like CTS expect the IV (req->info) of
> ablkcipher_request (or equivalently req->iv of skcipher_request) to
> contain the last ciphertext block when the {en,de}crypt operation is done.
>
> Fix this issue for the Atmel AES hardware engine. The tcrypt test
> case for cts(cbc(aes)) is now correctly passed.
>
> To handle the case of in-place decryption, copy the ciphertext in an
> intermediate buffer before decryption.
>

Unfortunately this does not seem to be enough. The tcrypt module's tests
pass, but I encounter more issues. If I run the libkcapi test suite, I
end up randomly with the following type of panic:

8< ----------------------------------------------------------------------

Unable to handle kernel paging request at virtual address 7ffffffc
pgd = dee9c000
[7ffffffc] *pgd=00000000
Internal error: Oops: 5 [#1] ARM
Modules linked in:
CPU: 0 PID: 2187 Comm: kcapi Not tainted 4.13.4+ #16
Hardware name: Atmel SAMA5
task: dec7f280 task.stack: dee82000
PC is at memcpy+0x114/0x330
LR is at atmel_aes_transfer_complete+0x64/0xe8
pc : [<c07ee5f4>]    lr : [<c05e419c>]    psr: 20000013
sp : dee83bcc  ip : 00000003  fp : dee83bfc
r10: 00000000  r9 : df638940  r8 : df638874
r7 : 00000010  r6 : 00000000  r5 : df638940  r4 : dec68110
r3 : 00004004  r2 : 0000000c  r1 : 7ffffffc  r0 : df638afc
Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
Control: 10c53c7d  Table: 3ee9c059  DAC: 00000051
Process kcapi (pid: 2187, stack limit = 0xdee82208)
Stack: (0xdee83bcc to 0xdee84000)
3bc0:                            df638afc dec68110 c05e419c 00000000 00000000
3be0: 00000030 dec68110 df557040 00000030 dee83c3c dee83c00 c05e61cc c05e4144
3c00: 10031000 dec68110 df6388a4 00000030 df6388a4 dec68110 df6388a4 00000030
3c20: 00000030 df638874 df557070 00000000 dee83c6c dee83c40 c05e488c c05e6064
3c40: df6388a4 df638874 dee83c6c dec68110 00000030 00000030 df6388a4 df638874
3c60: dee83c94 dee83c70 c05e4998 c05e471c 00000030 dec68110 df557040 00000000
3c80: df638874 df557070 dee83cd4 dee83c98 c05e6198 c05e48d4 c05e6058 00000000
3ca0: dee83cbc df6388a4 c041ab04 dec68110 00000000 df557040 df638940 ffffff8d
3cc0: a0000013 00000004 dee83d04 dee83cd8 c05e62f8 c05e6064 dee83d3c dee83ce8
3ce0: c01dbe9c dec68110 00000000 df638940 df638940 ffffff8d dee83d2c dee83d08
3d00: c05e4ac8 c05e61f8 df638940 00004000 df638800 df557000 00000020 df638860
3d20: dee83d44 dee83d30 c05e4b50 c05e4a14 df638874 00000400 dee83d54 dee83d48
3d40: c05e4ba0 c05e4af0 dee83d74 dee83d58 c034997c c05e4b90 df638840 df638800
3d60: dec3e4c0 00000000 dee83db4 dee83d78 c0368f70 c0349918 00000000 c03bfab0
3d80: df6388a4 df638afc dfff1bc2 df63898c df638988 df608800 00000040 df701000
3da0: df63898c dee83e28 dee83e1c dee83db8 c0393514 c0368e88 df701000 df608800
3dc0: 00000020 df638afc 0000030c 00000188 df63898c df638800 00000044 014000c0
3de0: df638ae8 00000040 dee83e20 df701000 00000040 dee83e80 c0392d48 df61ff00
3e00: df241200 dee83e80 0004a150 00000000 dee83e6c dee83e20 c0641d8c c0392d54
3e20: 00000000 00000000 00000000 00000000 00000000 dee83ea0 00000000 c0101254
3e40: 00000000 00000000 00000000 dee4f400 00000000 df61ff00 dee4f400 00000000
3e60: dee83efc dee83e70 c0242950 c0641cfc dee83e80 c07edac4 80000013 00000000
3e80: 00000000 00000000 00000040 dee83e98 00000001 c0101254 0004a298 00000040
3ea0: f7f27003 00000055 b6f27000 df644000 00000000 000000f6 c0108ea4 0004a150
3ec0: ffffe000 c021636c dee83ee4 dee83ed8 c021636c c02162d8 dee83efc 00049148
3ee0: 00000000 dee4f400 df61ff00 df557200 dee83fa4 dee83f00 c0243db8 c024285c
3f00: dee83f1c c0d05f40 c0d98a98 014080c0 c0d9ad5c 00000000 00000001 ffffe000
3f20: dee83f20 dee83f20 dee83f28 dee83f28 dee83f30 dee83f30 00000000 00000000
3f40: 00000000 00000000 00000000 00000007 0004a298 00000000 00000040 00000000
3f60: 00000000 00000000 00000000 00000000 00000001 00000006 0000011d b6f2bce8
3f80: 00000000 00000000 000000f6 c0108ea4 dee82000 00000000 00000000 dee83fa8
3fa0: c0108ce0 c0243734 b6f2bce8 00000000 b6f27000 00000001 0004a150 00049188
3fc0: b6f2bce8 00000000 00000000 000000f6 00000000 00000001 000490b8 000490d4
3fe0: bee3d838 bee3d828 b6ee63bc b6e73810 60000010 b6f27000 00000000 00000000
[<c07ee5f4>] (memcpy) from [<c05e419c>] (atmel_aes_transfer_complete+0x64/0xe8)
[<c05e419c>] (atmel_aes_transfer_complete) from [<c05e61cc>]
(atmel_aes_ctr_transfer+0x174/0x194)
[<c05e61cc>] (atmel_aes_ctr_transfer) from [<c05e488c>]
(atmel_aes_cpu_transfer+0x17c/0x1b8)
[<c05e488c>] (atmel_aes_cpu_transfer) from [<c05e4998>]
(atmel_aes_cpu_start+0xd0/0xd4)
[<c05e4998>] (atmel_aes_cpu_start) from [<c05e6198>]
(atmel_aes_ctr_transfer+0x140/0x194)
[<c05e6198>] (atmel_aes_ctr_transfer) from [<c05e62f8>]
(atmel_aes_ctr_start+0x10c/0x15c)
[<c05e62f8>] (atmel_aes_ctr_start) from [<c05e4ac8>]
(atmel_aes_handle_queue+0xc0/0xdc)
[<c05e4ac8>] (atmel_aes_handle_queue) from [<c05e4b50>]
(atmel_aes_crypt+0x6c/0xa0)
[<c05e4b50>] (atmel_aes_crypt) from [<c05e4ba0>]
(atmel_aes_ctr_decrypt+0x1c/0x20)
[<c05e4ba0>] (atmel_aes_ctr_decrypt) from [<c034997c>]
(skcipher_decrypt_ablkcipher+0x70/0x74)
[<c034997c>] (skcipher_decrypt_ablkcipher) from [<c0368f70>]
(crypto_ccm_decrypt+0xf4/0x13c)
[<c0368f70>] (crypto_ccm_decrypt) from [<c0393514>] (aead_recvmsg+0x7cc/0x8ec)
[<c0393514>] (aead_recvmsg) from [<c0641d8c>] (sock_read_iter+0x9c/0xcc)
[<c0641d8c>] (sock_read_iter) from [<c0242950>]
(aio_read.constprop.4+0x100/0x184)
[<c0242950>] (aio_read.constprop.4) from [<c0243db8>]
(SyS_io_submit+0x690/0x7b0)
[<c0243db8>] (SyS_io_submit) from [<c0108ce0>] (ret_fast_syscall+0x0/0x3c)
Code: e211c003 0affffc4 e3c11003 e35c0002 (e491e004)
---[ end trace c5d62710d279e751 ]---

This looks like a race condition that I introduced to store the encrypted
source for the final IV.


-- 
Romain Izard
