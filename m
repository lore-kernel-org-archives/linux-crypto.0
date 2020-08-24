Return-Path: <SRS0=tkOt=CC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C40DC433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Aug 2020 01:24:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0D10206F7
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Aug 2020 01:24:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HggBtFid"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbgHXBYj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 23 Aug 2020 21:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726635AbgHXBYj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 23 Aug 2020 21:24:39 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20A2FC061573;
        Sun, 23 Aug 2020 18:24:39 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id 83so6775399wme.4;
        Sun, 23 Aug 2020 18:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NSIdN4wC/zcQyCZ5Zy2jnOHZm7VotUNdlxCHScr1ABw=;
        b=HggBtFid/g9WbiE8JqX/0nbM6Ca5Ma7C1gUSIz6YbNjWRm6JZbs5kOb07MeOP70/yR
         Upwc06HxyyvSb2M7w1iSVQvnApr5lO2krO3sdiOJNhBVBXS503Uifw8035p6zMSZsuSh
         sOmYxuWAVUn5SAarWiZaxG8reFBaD9NpUDb9Hy0eRy4BgyXRR7EEucFaRb4R7iX7SxOU
         xmMbx46mCg1xuoetslQLmkmk00Zu98ZOzXzmiQanImXBVSwbPOqr2B2H+9y3oxoO5oGd
         1S3ZoAFRBARP2iYUkTjYXULWmkUXF5EvyGj2zkivllEObfdq3gQrBUg4rUOMYhi0tTD7
         b4+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NSIdN4wC/zcQyCZ5Zy2jnOHZm7VotUNdlxCHScr1ABw=;
        b=jEFga/2uxXI04zjGaZKfNGSGX+xB4PJlaNVWDvEip4y0Q7i24L8POZSf2Sp4KbJrWE
         p8ucRUKTOen7TufNBV8BUjZXWZTihotaiXAVKZlcx/OMZU7589ddEjXwVz29+ptA8+e3
         gqUMwBXT9CnMtFwh5zUIHtThbE9nSP34NiQXUXmCIe+jpuPIPfvBfyTlb8d9Hr/Ik6J5
         lnlrg7u7A3fkknZkdvok66HRVBByfKlYGZduXOHdAGbHN7/wXmbNYliFY2XJUM+7R5Ng
         m9odCDL7/X5/r5lyw1nPCwWaGCAGQzuMKW/lm87DotMFTP8/k7qVKW0uGfHFqPoLRCYX
         Bbfg==
X-Gm-Message-State: AOAM533ptJjeW2MRh0I/6vor4a7HAsYoQm+EwIJPnAOp0uj/nNSXFQbS
        PvdkjgMZOF7UjM6kfi8w1YQ=
X-Google-Smtp-Source: ABdhPJwn0MdTZzAjIEg5PvsPdtxanYv5AqVh+li+tKAOu9b2kdOe5zSI1o8XQ/h9YyiV7QD8W95MuA==
X-Received: by 2002:a1c:f00a:: with SMTP id a10mr3241216wmb.84.1598232275331;
        Sun, 23 Aug 2020 18:24:35 -0700 (PDT)
Received: from [192.168.1.236] (79.red-79-151-187.dynamicip.rima-tde.net. [79.151.187.79])
        by smtp.gmail.com with ESMTPSA id t14sm19680515wrv.14.2020.08.23.18.24.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Aug 2020 18:24:34 -0700 (PDT)
Subject: Re: [PATCH] Add missing bound checks for software 842 decompressor
To:     keescook@chromium.org
References: <202008191311.A4E1B54 () keescook>
Cc:     linux-kernel@vger.kernel.org, haren@us.ibm.com,
        linux-crypto@vger.kernel.org, ddstreet@ieee.org,
        herbert@gondor.apana.org.au
From:   Joan Bruguera <joanbrugueram@gmail.com>
Message-ID: <49007395-c193-f8af-6ba1-ab2a3a3df558@gmail.com>
Date:   Mon, 24 Aug 2020 03:24:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <202008191311.A4E1B54 () keescook>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 19.08.20 22:19, Kees Cook wrote:
> On Sun, Aug 16, 2020 at 02:33:41AM +0200, Joan Bruguera wrote:
>> Any feedback?
> 
> Hi!
> 
> I just happened to see this email. I think this should likely be
> directed to the crypto (which also handled compress/decompress APIs)
> list and the original author...
> 
> Additional notes below...
> 

Thanks for the review, much appreciated.

>> - Joan
>>
>> On 05.06.20 17:44, Joan Bruguera wrote:
>>> The software 842 decompressor receives, through the initial value of the
>>> 'olen' parameter, the capacity of the buffer pointed to by 'out'. If this
>>> capacity is insufficient to decode the compressed bitstream, -ENOSPC
>>> should be returned.
>>>
>>> However, the bounds checks are missing for index references (for those
>>> ops. where decomp_ops includes a I2, I4 or I8 subop.), and also for
>>> OP_SHORT_DATA. Due to this, sw842_decompress can write past the capacity
>>> of the 'out' buffer.
> 
> Eek. :(

It isn't much exploitable though, since AFAICT, compressed data can only 
come from zram or pstore, not from userspace.

> 
>>>
>>> The case for index references can be triggered by compressing data that
>>> follows a 16-byte periodic pattern (excluding special cases which are
>>> better encoded by OP_ZEROS) and passing a 'olen' somewhat smaller than the
>>> original length.
>>> The case for OP_SHORT_DATA can be triggered by compressing an amount of
>>> data that is not a multiple of 8, and then a slightly smaller 'olen' that
>>> can't fit those last <8 bytes.
>>>
>>> Following is a small test module to demonstrate the issue.
>>>
>>> -
>>>
>>> #include <linux/module.h>
>>> #include <linux/kernel.h>
>>> #include <linux/sw842.h>
>>>
>>> static unsigned char workspace[1000000] = { 0 }; // Hacky
>>>
>>> static void test_bound(const char *name, unsigned ibound, unsigned dbound)
>>> {
>>> 	uint8_t in[ibound], out[ibound * 4], decomp[ibound /* Overallocated */];
>>> 	unsigned clen = ibound * 4, dlen = dbound, i;
>>> 	int ret;
>>>
>>> 	for (i = 0; i < ibound; i ++)
>>> 		in[i] = i % 16; // 0, 1, 2, ..., 14, 15, 0, 1, 2, ...
>>> 	for (i = dbound; i < ibound; i++)
>>> 		decomp[i] = 0xFF; // Place guard bytes
>>>
>>> 	ret = sw842_compress(in, ibound, out, &clen, workspace);
>>> 	BUG_ON(ret != 0);
>>>
>>> 	ret = sw842_decompress(out, clen, decomp, &dlen);
>>> 	if (ret != -ENOSPC) {
>>> 		printk(KERN_ERR "%s: Expected ENOSPC to be returned\n", name);
>>> 	}
>>> 	for (i = dbound; i < ibound; i++) {
>>> 		if (decomp[i] != 0xFF) {
>>> 			printk(KERN_ERR "%s: Guard overwritten\n", name);
>>> 			break;
>>> 		}
>>> 	}
>>> }
>>>
>>> int init_module(void)
>>> {
>>> 	test_bound("Index reference test", 256, 64);
>>> 	test_bound("Short data test", 12, 8);
>>> 	return -ECANCELED; // Do not leave this test module hanging around
>>> }
>>>
>>> void cleanup_module(void)
>>> {
>>> }
>>>
>>> MODULE_LICENSE("GPL");
>>> MODULE_SOFTDEP("pre: 842");
> 
> Can this test be added to the kernel source directly? It'd be nice to
> add such a regression test.
> 

I took a look and maybe it could go into the crypto self tests (in 
crypto/testmgr.c)... but I'm not really sure if it fits there, since 
this would be a regression test rather than the smoke tests that seem to 
make most of that file, and this bug requires adding a custom method 
testing whether the decompressor respects the output buffer size rather 
than a simple test with just a simple input / output data test vector.

Were thinking of that, something else (e.g. Linux Test Project), or just 
suggesting?

>>>
>>> Signed-off-by: Joan Bruguera <joanbrugueram@gmail.com>
>>> ---
>>>    lib/842/842_decompress.c | 6 ++++++
>>>    1 file changed, 6 insertions(+)
>>>
>>> diff --git a/lib/842/842_decompress.c b/lib/842/842_decompress.c
>>> index 582085ef8b4..c29fbfc9d08 100644
>>> --- a/lib/842/842_decompress.c
>>> +++ b/lib/842/842_decompress.c
>>> @@ -202,6 +202,9 @@ static int __do_index(struct sw842_param *p, u8 size, u8 bits, u64 fsize)
>>>    			 (unsigned long)total,
>>>    			 (unsigned long)beN_to_cpu(&p->ostart[offset], size));
>>> +	if (size > p->olen)
>>> +		return -ENOSPC;
>>> +
>>>    	memcpy(p->out, &p->ostart[offset], size);
>>>    	p->out += size;
>>>    	p->olen -= size;
>>> @@ -345,6 +348,9 @@ int sw842_decompress(const u8 *in, unsigned int ilen,
>>>    			if (!bytes || bytes > SHORT_DATA_BITS_MAX)
>>>    				return -EINVAL;
>>> +			if (bytes > p.olen)
>>> +				return -ENOSPC;
>>> +
>>>    			while (bytes-- > 0) {
>>>    				ret = next_bits(&p, &tmp, 8);
>>>    				if (ret)
>>>
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> 
> 
