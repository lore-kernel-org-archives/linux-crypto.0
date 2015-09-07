From: Andrzej Zaborowski <andrew.zaborowski@intel.com>
Subject: Re: [RFC PATCH] crypto: RSA padding transform
Date: Mon, 7 Sep 2015 16:38:50 +0200
Message-ID: <CAOq732LKEfbVOWqiBzB7RpGY5ofpEYN-NTf_yyT9Ncq7=CPsvw@mail.gmail.com>
References: <1441494029-6765-1-git-send-email-andrew.zaborowski@intel.com>
	<55ED99DE.2000004@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:38297 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbbIGOiv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 Sep 2015 10:38:51 -0400
Received: by wiclk2 with SMTP id lk2so86346481wic.1
        for <linux-crypto@vger.kernel.org>; Mon, 07 Sep 2015 07:38:50 -0700 (PDT)
In-Reply-To: <55ED99DE.2000004@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Tadeusz,

On 7 September 2015 at 16:06, Tadeusz Struk <tadeusz.struk@intel.com> wrote:
> Hi Andrew,
> On 09/05/2015 04:00 PM, Andrew Zaborowski wrote:
>> +static int crypto_akcipher_init(struct crypto_tfm *tfm, u32 type, u32 mask)
>> +{
>> +     return 0;
>> +}
>> +
>
> This is not needed I think.

To create the padding transform I needed to use crypto_spawn_tfm which
then calls -> __crypto_alloc_tfm -> crypto_init_ops resulting in a
call to crypto_akcipher_type.init().

>
>>
>> +static int pkcs1pad_decrypt_complete(struct akcipher_request *req, int err)
>> +{
>> +     struct akcipher_request *child_req = akcipher_request_ctx(req);
>> +     int pos;
>> +     uint8_t *dst = child_req->dst;
>> +
>> +     BUG_ON(err == -EOVERFLOW);
>> +
>> +     if (err)
>> +             goto done;
>> +
>> +     if (dst[0] != 0x00) {
>> +             err = -EINVAL;
>> +             goto done;
>> +     }
>
> This won't work I'm afraid, because MPI strips all leading zeors.

Good point, I have been testing against a version from before your
change to mpi_read_buffer which strips the leading zeros.  I'll retest
and update the patch after your other akcipher work is submitted.

Best regards
