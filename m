From: Stephan Mueller <smueller@chronox.de>
Subject: Re: Test AEAD/authenc algorithms from userspace
Date: Tue, 31 May 2016 11:21:55 +0200
Message-ID: <3164476.NJZyJLbx96@tauon.atsec.com>
References: <CAFXBA=kStufh3TDe=+qQYmd2tNCj9hgXLUKBeoZHBs2VxRBRbQ@mail.gmail.com> <2892187.M1JfTODgdh@tauon.atsec.com> <CAFXBA=mfw3tcftwo9nEihJHVKQzdRVg3HXJOkn8CT5VtYNxbxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Harsh Jain <harshjain.prof@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:35184 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757020AbcEaJV7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 May 2016 05:21:59 -0400
In-Reply-To: <CAFXBA=mfw3tcftwo9nEihJHVKQzdRVg3HXJOkn8CT5VtYNxbxQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 31. Mai 2016, 14:45:27 schrieb Harsh Jain:

Hi Harsh,

> Hi,
> 
> Thanks Stephen, I will check the same.1 suggestion for kcapi tool. Add
> some switch cases in tool to test digest and finup path of crypto
> driver. Current implementation triggers only init/update/final.

You mean for hashes? I guess the following is what you refer to? This logic is 
even found for the other cipher types (symmetric algos, AEAD ciphers). See the 
documentation on stream vs one-shot use cases.

/**
 * kcapi_md_init() - initialize cipher handle
 * @handle: cipher handle filled during the call - output
 * @ciphername: kernel crypto API cipher name as specified in
 *             /proc/crypto - input
 * @flags: flags specifying the type of cipher handle
 *
 * This function provides the initialization of a (keyed) message digest 
handle
 * and establishes the connection to the kernel.
 *
 * Return: 0 upon success; ENOENT - algorithm not available;
 *         -EOPNOTSUPP - AF_ALG family not available;
 *         -EINVAL - accept syscall failed
 *         -ENOMEM - cipher handle cannot be allocated
 */
int kcapi_md_init(struct kcapi_handle **handle, const char *ciphername,
                  uint32_t flags);

/**
 * kcapi_md_update() - message digest update function (stream)
 * @handle: cipher handle - input
 * @buffer: holding the data to add to the message digest - input
 * @len: buffer length - input
 *
 * Return: 0 upon success;
 *         < 0 in case of error
 */
int32_t kcapi_md_update(struct kcapi_handle *handle,
                        const uint8_t *buffer, uint32_t len);

/**
 * kcapi_md_final() - message digest finalization function (stream)
 * @handle: cipher handle - input
 * @buffer: filled with the message digest - output
 * @len: buffer length - input
 *
 * Return: size of message digest upon success;
 *         -EIO - data cannot be obtained;
 *         -ENOMEM - buffer is too small for the complete message digest,
 *         the buffer is filled with the truncated message digest
 */
int32_t kcapi_md_final(struct kcapi_handle *handle,
                       uint8_t *buffer, uint32_t len);


The test/kcapi tool is a crude test tool that I use for my regression testing. 
It is not intended for anything else.
> 
> 
> Regards
> Harsh Jain
> 
> On Tue, May 31, 2016 at 2:29 PM, Stephan Mueller <smueller@chronox.de> 
wrote:
> > Am Dienstag, 31. Mai 2016, 14:10:20 schrieb Harsh Jain:
> > 
> > Hi Harsh,
> > 
> >> Hi,
> >> 
> >> You means to say like this
> >> 
> >> ./kcapi -x 2 -e -c "authenc(hmac(sha1),cbc(aes))" -p
> >> 48981da18e4bb9ef7e2e3162d16b19108b19050f66582cb7f7e4b6c873819b71 -k
> >> 8d7dd9b0170ce0b5f2f8e1aa768e01e91da8bfc67fd486d081b28254c99eb423 -i
> >> 7fbc02ebf5b93322329df9bfccb635af -a afcd7202d621e06ca53b70c2bdff7fb2
> >> -l 16f4a3eacfbdadd3b1a17117b1d67ffc1f1e21efbbc6d83724a8c296e3bb8cda0c44
> >> 
> >> It gives following error with kernel 4.5.2
> >> Symmetric cipher setkey failed
> >> Failed to invoke testing
> > 
> > Please see testmgr.h for usage (especially the key encoding):
> > 
> > invocation:
> > ./kcapi -x 2 -e -c "authenc(hmac(sha1),cbc(aes))" -p
> > 53696e676c6520626c6f636b206d7367 -k
> > 0800010000000010000000000000000000000000000000000000000006a9214036b8a15b51
> > 2e03d534120006 -i 3dafba429d9eb430b422da802c9fac41 -a
> > 3dafba429d9eb430b422da802c9fac41 -l 20
> > 
> > return:
> > e353779c1079aeb82708942dbe77181a1b13cbaf895ee12c13c52ea3cceddcb50371a206
> > 
> > This is the first test of hmac_sha1_aes_cbc_enc_tv_temp (RFC3601 case 1).
> > Note, the input string of "Single block msg" was converted to hex
> > 53696e676c6520626c6f636b206d7367 as my tool always treats all input data
> > as
> > hex data.
> > 
> >> Regards
> >> Harsh Jain
> >> 
> >> On Tue, May 31, 2016 at 12:35 PM, Stephan Mueller <smueller@chronox.de>
> > 
> > wrote:
> >> > Am Dienstag, 31. Mai 2016, 12:31:16 schrieb Harsh Jain:
> >> > 
> >> > Hi Harsh,
> >> > 
> >> >> Hi All,
> >> >> 
> >> >> How can we open socket of type "authenc(hmac(sha256),cbc(aes))" from
> >> >> userspace program.I check libkcapi library. It has test programs for
> >> >> GCM/CCM. There are 3 types of approaches to Authenticated Encryption,
> >> >> Which of them is supported in crypto framework.
> >> >> 
> >> >> 1) Encrypt-then-MAC (EtM)
> >> >> 
> >> >>      The plaintext is first encrypted, then a MAC is produced based on
> >> >> 
> >> >> the resulting ciphertext. The ciphertext and its MAC are sent
> >> >> together.
> >> >> 2) Encrypt-and-MAC (E&M)
> >> >> 
> >> >>      A MAC is produced based on the plaintext, and the plaintext is
> >> >> 
> >> >> encrypted without the MAC. The plaintext's MAC and the ciphertext are
> >> >> sent together.
> >> >> 
> >> >> 3) MAC-then-Encrypt (MtE)
> >> >> 
> >> >>      A MAC is produced based on the plaintext, then the plaintext and
> >> >> 
> >> >> MAC are together encrypted to produce a ciphertext based on both. The
> >> >> ciphertext (containing an encrypted MAC) is sent.
> >> > 
> >> > The cipher types you mention refer to the implementation of authenc().
> >> > IIRC, authenc implements EtM as this is mandated by IPSEC.
> >> > 
> >> > When you use libkcapi, you should simply be able to use your cipher
> >> > name
> >> > with the AEAD API. I.e. use the examples you see for CCM or GCM and use
> >> > those with the chosen authenc() cipher. Do you experience any issues?
> >> > 
> >> > Ciao
> >> > Stephan
> > 
> > Ciao
> > Stephan


Ciao
Stephan
