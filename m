Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BBE9C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Feb 2022 03:16:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232025AbiBRDQ2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Feb 2022 22:16:28 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:59024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231966AbiBRDQD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Feb 2022 22:16:03 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFC491BBF72
        for <linux-crypto@vger.kernel.org>; Thu, 17 Feb 2022 19:15:42 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id x18so1283818pfh.5
        for <linux-crypto@vger.kernel.org>; Thu, 17 Feb 2022 19:15:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Cvti9DbyWYs8dMjlWXIsVfLl8mOEd5qxZxKU5ZS8qhM=;
        b=EnqUrDW/nfup+NhWajLnkDWhSOvmFoQK+dIo4ycSZlbsaVZJQ3toa0sV/8PDtLpVtc
         Ua0hdYljmfKvlJdq+WpMj2cGgilXh8rXHSlRESdUebGxMXfw/A205qgyBOIEVWv+4brN
         NG9GiLi0ZFqeHR/zxleMZYNtBDRe15bxJfg3g6yujkyJ6YLRflwF2dEv+AXmhyQvEDPx
         iaqI9kaMr1J66C769SPr6XBkLO0cER66YfEcxLJ/YbkQLScKp1HiLAfpbDFm2hc6/00x
         Iij4aCq5PBkd0bXF/fU869XzGKcQR0BoA78b38hn4VifEuBUufctF3qushtC1R+qGyZk
         9N+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Cvti9DbyWYs8dMjlWXIsVfLl8mOEd5qxZxKU5ZS8qhM=;
        b=VA+AONCM++QxrjsgAVY+SXuBZQIpFM+AOwU5Hd4GTzSYhuHWdrxhDR7YbrCtKbnzRG
         qVPAX3g8JfQ6/Mbb/2K75RypY8r1pHPj4AK6soBEFWuKBQ2p0mIhxqtpxnrexEPP8Q3q
         ofPF1xRMFztl8F+gi8jdzQwSHUOBZwQNvcRSpRTtXJ3BBSIF9AxWuDi0kUZUqJG9F4v8
         1ihAU1kh1rueDy7wOZvy/rCND2IJ6gWfspfDTNe4cTmiGJNdcGNfKdG/ybfFBsaRsfYL
         zlAKSXYclkHr9Bkg8tYCVhl4OOX+5zKB6oCp0vfHqZWCfByQqfMMePIRWDfC8XXH66xK
         qyAw==
X-Gm-Message-State: AOAM533yFd7bKa0U/BG55kNXI885o7cWM0kWXX7Q5TcuCs0bd+l0Lvdl
        5gk8c3Yuky/7NBGX6ZgHxh1zLw==
X-Google-Smtp-Source: ABdhPJxR3+NulIemLCe52Otg1HdG7AnjP7K5Epp9CJhpKw23x3HRAJOPywscd3ggEHJRYfc4lVgE9Q==
X-Received: by 2002:a63:f90e:0:b0:373:da89:c0bd with SMTP id h14-20020a63f90e000000b00373da89c0bdmr462001pgi.135.1645154142317;
        Thu, 17 Feb 2022 19:15:42 -0800 (PST)
Received: from [10.76.15.169] ([61.120.150.76])
        by smtp.gmail.com with ESMTPSA id m19sm929643pfk.215.2022.02.17.19.15.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Feb 2022 19:15:41 -0800 (PST)
Subject: Re: RE: [PATCH v2 3/3] virtio-crypto: implement RSA algorithm
To:     "Gonglei (Arei)" <arei.gonglei@huawei.com>
Cc:     "jasowang@redhat.com" <jasowang@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "helei.sig11@bytedance.com" <helei.sig11@bytedance.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        kernel test robot <lkp@intel.com>
References: <20220211084108.1254218-1-pizhenwei@bytedance.com>
 <20220211084108.1254218-4-pizhenwei@bytedance.com>
 <c9144b0d82e34566a960f210ddc32696@huawei.com>
From:   zhenwei pi <pizhenwei@bytedance.com>
Message-ID: <8ef2f660-bd84-de70-1539-402c73795dfe@bytedance.com>
Date:   Fri, 18 Feb 2022 11:12:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <c9144b0d82e34566a960f210ddc32696@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

>> +void virtio_crypto_akcipher_algs_unregister(struct virtio_crypto
>> +*vcrypto) {
>> +	int i = 0;
>> +
>> +	mutex_lock(&algs_lock);
>> +
>> +	for (i = 0; i < ARRAY_SIZE(virtio_crypto_akcipher_algs); i++) {
>> +		uint32_t service = virtio_crypto_akcipher_algs[i].service;
>> +		uint32_t algonum = virtio_crypto_akcipher_algs[i].algonum;
>> +
>> +		if (virtio_crypto_akcipher_algs[i].active_devs == 0 ||
>> +		    !virtcrypto_algo_is_supported(vcrypto, service, algonum))
>> +			continue;
>> +
>> +		if (virtio_crypto_akcipher_algs[i].active_devs == 1)
>> +
>> 	crypto_unregister_akcipher(&virtio_crypto_akcipher_algs[i].algo);
>> +
>> +		virtio_crypto_akcipher_algs[i].active_devs--;
>> +	}
>> +
>> +	mutex_unlock(&algs_lock);
>> +}
> 
> Why don't you reuse the virtio_crypto_algs_register/unregister functions?
> The current code is too repetitive. Maybe we don't need create the new file virtio_crypto_akcipher_algo.c
> because we had virtio_crypto_algs.c which includes all algorithms.
> 

Yes, this looks similar to virtio_crypto_algs_register/unregister.

Let's look at the difference:
struct virtio_crypto_akcipher_algo {
         uint32_t algonum;
         uint32_t service;
         unsigned int active_devs;
         struct akcipher_alg algo;
};

struct virtio_crypto_algo {
         uint32_t algonum;
         uint32_t service; 

         unsigned int active_devs;
         struct skcipher_alg algo; /* akcipher_alg VS skcipher_alg */
};

If reusing virtio_crypto_algs_register/unregister, we need to modify the 
data structure like this:
struct virtio_crypto_akcipher_algo {
         uint32_t algonum;
         uint32_t service;	/* use service to distinguish 
akcipher/skcipher */
         unsigned int active_devs;
	union {
		struct skcipher_alg skcipher;
	        struct akcipher_alg akcipher;
	} alg;
};

int virtio_crypto_akcipher_algs_register(struct virtio_crypto *vcrypto)
{
	...
         for (i = 0; i < ARRAY_SIZE(virtio_crypto_akcipher_algs); i++) {
                 uint32_t service = virtio_crypto_akcipher_algs[i].service;
		...
		/* test service type then call 
crypto_register_akcipher/crypto_register_skcipher */
                 if (service == VIRTIO_CRYPTO_SERVICE_AKCIPHER)
			crypto_register_akcipher(&virtio_crypto_akcipher_algs[i].algo.akcipher);
		else
			crypto_register_skcipher(&virtio_crypto_skcipher_algs[i].algo.skcipher);
		...
         }
	...
}

Also test service type and call 
crypto_unregister_skcipher/crypto_unregister_akcipher.

This gets unclear from current v2 version.

On the other hand, the kernel side prefers to separate skcipher and 
akcipher(separated header files and implementations).

-- 
zhenwei pi
