Return-Path: <SRS0=Wq3S=VB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B449FC0651F
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Jul 2019 17:45:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76DE1218A3
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Jul 2019 17:45:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JNMlUM3A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbfGDRpy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Jul 2019 13:45:54 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41434 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726411AbfGDRpy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Jul 2019 13:45:54 -0400
Received: by mail-wr1-f68.google.com with SMTP id c2so7399251wrm.8
        for <linux-crypto@vger.kernel.org>; Thu, 04 Jul 2019 10:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3nRBrnBKl48XJ4HetTkVACHbkJVQ5SGg8j9fWK7a8bw=;
        b=JNMlUM3AVJWIGaC/lhtZyP7AxqEoFoiChSyMM2+66KKPTtoIflNK2ka7KWAOgPPLgA
         jj5Gykg+cTNo5xuu3cQ7P3bfyFRAEfIqIgckXIlyKe13aGo28MZ6Xmx0YET7bFYlm4fJ
         +KFLyp1Jj690JG4hi9SOnqlZ9TLeVKJ/HwaZqLZkx56QPLFJ0Gol7EeRsCmNNdD2lS0s
         z0SUVGfcjIvuBIohHWBppUQGlsWyvuedgj4zg5/WJUh+IYyODe2tENtXx/e4nhURHHkI
         K+0xdnod8IGnH52xXM4kTXLqUKoySMuR7LSVlCHuAbx1wmpBbACrrSGCsm6qE7oOCHmU
         yjGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3nRBrnBKl48XJ4HetTkVACHbkJVQ5SGg8j9fWK7a8bw=;
        b=enXgJThPfSIwkbbyq/TOZNk+NW95WNIOkVV2taMp8ltzvRA8OvfKTVVNrUGlVaIR+l
         JJ7ONtPg/+sFJTxQPOk/ZCsQsT7B3KoMnDzW+MHEuK3pHaSMWLuYa5/M2LtcgT5fSCtx
         kmTASS23v6cPbKfuhKBjqD40ewgdciINlq6mJR87g1ctunPYnG2ZTRESl7bTCvZDGPYn
         /vTDMEFenCvFm3z7UN4Z0B+iVX6OxIxe0ZBtubJ4E9pK2RYZAFC2VhlbWaexcD4HabR3
         7mZFhJMVD30l1eYhtRm1gEJ7mCArn1zHdQOOm8xpLJIQSCl1ObfDqznmV6F4mZHqdP6C
         UCbg==
X-Gm-Message-State: APjAAAWhq2ejAi7+IoS4OJk+x5j1Gx5X72Y6zpssPf7GUEM9V9NMub/E
        Aslds3JlzBUsjoQbGOfQIBndPw0Z
X-Google-Smtp-Source: APXvYqw7kHPlE5Ynevtrcl7U9CAMC+4Lw3aJ85LSyfkjHyeQG9l5cFBG244cOB/CTSzPpr+hWcKEFQ==
X-Received: by 2002:adf:e442:: with SMTP id t2mr36130520wrm.286.1562262350928;
        Thu, 04 Jul 2019 10:45:50 -0700 (PDT)
Received: from [192.168.8.100] (37-48-34-161.nat.epc.tmcz.cz. [37.48.34.161])
        by smtp.gmail.com with ESMTPSA id c1sm9823972wrh.1.2019.07.04.10.45.49
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Jul 2019 10:45:50 -0700 (PDT)
Subject: Re: [PATCH 3/3] dm-crypt: Implement eboiv - encrypted byte-offset
 initialization vector.
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@google.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        device-mapper development <dm-devel@redhat.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
References: <20190704131033.9919-1-gmazyland@gmail.com>
 <20190704131033.9919-3-gmazyland@gmail.com>
 <7a8d13ee-2d3f-5357-48c6-37f56d7eff07@gmail.com>
 <CAKv+Gu_c+OpOwrr0dSM=j=HiDpfM4sarq6u=6AXrU8jwLaEr-w@mail.gmail.com>
 <CAKv+Gu8a6cBQYsbYs8CDyGbhHx0E=+1SU7afqoy9Cs+K8PMfqA@mail.gmail.com>
From:   Milan Broz <gmazyland@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <4286b8f6-03b5-a8b4-4db2-35dda954e518@gmail.com>
Date:   Thu, 4 Jul 2019 19:45:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAKv+Gu8a6cBQYsbYs8CDyGbhHx0E=+1SU7afqoy9Cs+K8PMfqA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 04/07/2019 16:30, Ard Biesheuvel wrote:
> On Thu, 4 Jul 2019 at 16:28, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>>
>> (+ Eric)
>>
>> On Thu, 4 Jul 2019 at 15:29, Milan Broz <gmazyland@gmail.com> wrote:
>>>
>>> Hi Herbert,
>>>
>>> I have a question about the crypto_cipher API in dm-crypt:
>>>
>>> We are apparently trying to deprecate cryto_cipher API (see the ESSIV patchset),
>>> but I am not sure what API now should be used instead.
>>>
>>
>> Not precisely - what I would like to do is to make the cipher part of
>> the internal crypto API. The reason is that there are too many
>> occurrences where non-trivial chaining modes have been cobbled
>> together from the cipher API.

Well, in the ESSIV case I understand there are two in-kernel users, so it makes
perfect sense to use common crypto API implementation.

For the rest, I perhaps still do not understand the reason to move this API
to "internal only" state.

(I am sure people will find an another way to to construct crazy things,
even if they are forced to use skcipher API. 8-)

>>> See the patch below - all we need is to one block encryption for IV.
>>>
>>> This algorithm makes sense only for FDE (old compatible Bitlocker devices),
>>> I really do not want this to be shared in some crypto module...
>>>
>>> What API should I use here? Sync skcipher? Is the crypto_cipher API
>>> really a problem in this case?
>>>
>>
>> Are arbitrary ciphers supported? Or are you only interested in AES? In
>> the former case, I'd suggest the sync skcipher API to instantiate
>> "ecb(%s)", otherwise, use the upcoming AES library interface.

For the Bitlocker compatibility, it is only AES in CBC mode, but we usually do
not limit IV use in dmcrypt.
(We still need to solve the Bitlocker Elephant diffuser, but that's another issue.)

> Actually, if CBC is the only supported mode, you could also use the
> skcipher itself to encrypt a single block of input (just encrypt the
> IV using CBC but with an IV of all zeroes)

I can then use ECB skcipher directly (IOW use skcipher ecb(aes) for IV).
(ECB mode must be present, because XTS is based on it anyway.)

Why I am asking is that with sync skcipher it means allocation of request
on stack - still more code than the patch I posted below.

We can do that. But if the crypto_cipher API stays exported, I do not see any
reason to write more complicated code.

We (dmcrypt) are pretty sophisticated user of crypto API already :)

Thanks,
Milan

> 
> 
>>> On 04/07/2019 15:10, Milan Broz wrote:
>>>> This IV is used in some BitLocker devices with CBC encryption mode.
>>>>
>>>> NOTE: maybe we need to use another crypto API if the bare cipher
>>>>       API is going to be deprecated.
>>>>
>>>> Signed-off-by: Milan Broz <gmazyland@gmail.com>
>>>> ---
>>>>  drivers/md/dm-crypt.c | 82 ++++++++++++++++++++++++++++++++++++++++++-
>>>>  1 file changed, 81 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
>>>> index 96ead4492787..a5ffa1ac6a28 100644
>>>> --- a/drivers/md/dm-crypt.c
>>>> +++ b/drivers/md/dm-crypt.c
>>>> @@ -120,6 +120,10 @@ struct iv_tcw_private {
>>>>       u8 *whitening;
>>>>  };
>>>>
>>>> +struct iv_eboiv_private {
>>>> +     struct crypto_cipher *tfm;
>>>> +};
>>>> +
>>>>  /*
>>>>   * Crypt: maps a linear range of a block device
>>>>   * and encrypts / decrypts at the same time.
>>>> @@ -159,6 +163,7 @@ struct crypt_config {
>>>>               struct iv_benbi_private benbi;
>>>>               struct iv_lmk_private lmk;
>>>>               struct iv_tcw_private tcw;
>>>> +             struct iv_eboiv_private eboiv;
>>>>       } iv_gen_private;
>>>>       u64 iv_offset;
>>>>       unsigned int iv_size;
>>>> @@ -290,6 +295,10 @@ static struct crypto_aead *any_tfm_aead(struct crypt_config *cc)
>>>>   *       is calculated from initial key, sector number and mixed using CRC32.
>>>>   *       Note that this encryption scheme is vulnerable to watermarking attacks
>>>>   *       and should be used for old compatible containers access only.
>>>> + *
>>>> + * eboiv: Encrypted byte-offset IV (used in Bitlocker in CBC mode)
>>>> + *        The IV is encrypted little-endian byte-offset (with the same key
>>>> + *        and cipher as the volume).
>>>>   */
>>>>
>>>>  static int crypt_iv_plain_gen(struct crypt_config *cc, u8 *iv,
>>>> @@ -838,6 +847,67 @@ static int crypt_iv_random_gen(struct crypt_config *cc, u8 *iv,
>>>>       return 0;
>>>>  }
>>>>
>>>> +static void crypt_iv_eboiv_dtr(struct crypt_config *cc)
>>>> +{
>>>> +     struct iv_eboiv_private *eboiv = &cc->iv_gen_private.eboiv;
>>>> +
>>>> +     crypto_free_cipher(eboiv->tfm);
>>>> +     eboiv->tfm = NULL;
>>>> +}
>>>> +
>>>> +static int crypt_iv_eboiv_ctr(struct crypt_config *cc, struct dm_target *ti,
>>>> +                         const char *opts)
>>>> +{
>>>> +     struct iv_eboiv_private *eboiv = &cc->iv_gen_private.eboiv;
>>>> +     struct crypto_cipher *tfm;
>>>> +
>>>> +     tfm = crypto_alloc_cipher(cc->cipher, 0, 0);
>>>> +     if (IS_ERR(tfm)) {
>>>> +             ti->error = "Error allocating crypto tfm for EBOIV";
>>>> +             return PTR_ERR(tfm);
>>>> +     }
>>>> +
>>>> +     if (crypto_cipher_blocksize(tfm) != cc->iv_size) {
>>>> +             ti->error = "Block size of EBOIV cipher does "
>>>> +                         "not match IV size of block cipher";
>>>> +             crypto_free_cipher(tfm);
>>>> +             return -EINVAL;
>>>> +     }
>>>> +
>>>> +     eboiv->tfm = tfm;
>>>> +     return 0;
>>>> +}
>>>> +
>>>> +static int crypt_iv_eboiv_init(struct crypt_config *cc)
>>>> +{
>>>> +     struct iv_eboiv_private *eboiv = &cc->iv_gen_private.eboiv;
>>>> +     int err;
>>>> +
>>>> +     err = crypto_cipher_setkey(eboiv->tfm, cc->key, cc->key_size);
>>>> +     if (err)
>>>> +             return err;
>>>> +
>>>> +     return 0;
>>>> +}
>>>> +
>>>> +static int crypt_iv_eboiv_wipe(struct crypt_config *cc)
>>>> +{
>>>> +     /* Called after cc->key is set to random key in crypt_wipe() */
>>>> +     return crypt_iv_eboiv_init(cc);
>>>> +}
>>>> +
>>>> +static int crypt_iv_eboiv_gen(struct crypt_config *cc, u8 *iv,
>>>> +                         struct dm_crypt_request *dmreq)
>>>> +{
>>>> +     struct iv_eboiv_private *eboiv = &cc->iv_gen_private.eboiv;
>>>> +
>>>> +     memset(iv, 0, cc->iv_size);
>>>> +     *(__le64 *)iv = cpu_to_le64(dmreq->iv_sector * cc->sector_size);
>>>> +     crypto_cipher_encrypt_one(eboiv->tfm, iv, iv);
>>>> +
>>>> +     return 0;
>>>> +}
>>>> +
>>>>  static const struct crypt_iv_operations crypt_iv_plain_ops = {
>>>>       .generator = crypt_iv_plain_gen
>>>>  };
>>>> @@ -890,6 +960,14 @@ static struct crypt_iv_operations crypt_iv_random_ops = {
>>>>       .generator = crypt_iv_random_gen
>>>>  };
>>>>
>>>> +static struct crypt_iv_operations crypt_iv_eboiv_ops = {
>>>> +     .ctr       = crypt_iv_eboiv_ctr,
>>>> +     .dtr       = crypt_iv_eboiv_dtr,
>>>> +     .init      = crypt_iv_eboiv_init,
>>>> +     .wipe      = crypt_iv_eboiv_wipe,
>>>> +     .generator = crypt_iv_eboiv_gen
>>>> +};
>>>> +
>>>>  /*
>>>>   * Integrity extensions
>>>>   */
>>>> @@ -2293,6 +2371,8 @@ static int crypt_ctr_ivmode(struct dm_target *ti, const char *ivmode)
>>>>               cc->iv_gen_ops = &crypt_iv_benbi_ops;
>>>>       else if (strcmp(ivmode, "null") == 0)
>>>>               cc->iv_gen_ops = &crypt_iv_null_ops;
>>>> +     else if (strcmp(ivmode, "eboiv") == 0)
>>>> +             cc->iv_gen_ops = &crypt_iv_eboiv_ops;
>>>>       else if (strcmp(ivmode, "lmk") == 0) {
>>>>               cc->iv_gen_ops = &crypt_iv_lmk_ops;
>>>>               /*
>>>> @@ -3093,7 +3173,7 @@ static void crypt_io_hints(struct dm_target *ti, struct queue_limits *limits)
>>>>
>>>>  static struct target_type crypt_target = {
>>>>       .name   = "crypt",
>>>> -     .version = {1, 18, 1},
>>>> +     .version = {1, 19, 0},
>>>>       .module = THIS_MODULE,
>>>>       .ctr    = crypt_ctr,
>>>>       .dtr    = crypt_dtr,
>>>>
