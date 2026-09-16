Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACBB84EE86E
	for <linux-crypto@vger.kernel.org>; Wed, 16 Sep 2026 10:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789555342; cv=none; b=gR6GylNV8VpejlMqgRy9WbdG31VtfdbijL3AchgIfc/DP3zZ9JAUpnuG/AqQDfhxPr+1zAsorN3uY1AdTAeEjr/7NJ2KiCsUNOiCcj+c9aS/hgbrBY2oUK68xLcAb+6djiZdo1v/qv48BSdmvcf7IEW5CMHi1se09zkAjTbLIMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789555342; c=relaxed/simple;
	bh=eVJoUUu1vh+Q4rpBKcndq3rAbbsf+tdm2+nwKfuQxQ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IVgLAUTdCNnMbvpI9KelnP7e+pAd0wraS6qIQKXpuFTvz370Lm5GgPV9JJ0aOnN4ajADCnBYji/YkhduUSrlzbtv9Tbe5kuO68MrdQlDZLSV9z5ZD8uPiSjuN5xbc9R0PtFqH0AcylRu9mzbNcRIlesXlGknEoj820WFU8sk6ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AeP7BmWv; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Rzn+AlcJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AeP7BmWv";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rzn+AlcJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789555330;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CHL1OjpjiRGJmzanwLT/SWwl4lrAjZJOnbpjxXj7sXU=;
	b=AeP7BmWvQuCIpHxKVe41v1tCAkc9S8Q1nBGqOKzdeO6PkHDouSjpE+Bh4aqnJOn0VIwgyb
	S53RBxJFjZv17AP607bqY8FwNEK4Tl72AnYMBdfLmCzK0Aewuqzq1nRr1Y1w8Qx5Lb0nHA
	RcTAfWT61TPFMehEcxybVEcJ83xayrE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-611-9yIocot8MOume11zoO0EQg-1; Wed, 16 Sep 2026 06:42:09 -0400
X-MC-Unique: 9yIocot8MOume11zoO0EQg-1
X-Mimecast-MFC-AGG-ID: 9yIocot8MOume11zoO0EQg_1789555328
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-490a767c7dcso45105945e9.2
        for <linux-crypto@vger.kernel.org>; Wed, 16 Sep 2026 03:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789555328; x=1790160128; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CHL1OjpjiRGJmzanwLT/SWwl4lrAjZJOnbpjxXj7sXU=;
        b=Rzn+AlcJXj3mOtbYuGlEztXUckDlBkDlPz/Ujj/tcnEgzTIt4cm8qL3G5wBV5175Go
         iyOkT2pjXwKK0MALhdLYNriCFL04JlebuOC+yv1UGtTLp6HSK/Xi81S5F86zubWgltKa
         DjkL5z92FmZHSmMzQ6rlhM1y6e08fB+Mvno/9MZvRlxV/pEgejqR7uAL9c+eDEwxzsLP
         MdZd01CbT+uEMZ7yPdMKTQkiT7diLDkijZl7haMjWbjxN/jo75287Ts7OnJuxyiadhjN
         d0rQmFKqt/iXBbjn5NbJDNoWKpqMwgxfzS8cMZ3Jo9kfrF/qkFlJbSmcHLCIT2XH9POg
         R7nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789555328; x=1790160128;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CHL1OjpjiRGJmzanwLT/SWwl4lrAjZJOnbpjxXj7sXU=;
        b=GMA4XeOkdMjFClCCrm5Bv/CUjxlB2XQXYZj9a13fqmVJs0ohwnkzcdLpLCQEoe+ShZ
         SI6wS+qI/BvNSJ6YV778xFzpDtu++ZqC5MrpiqeC2N4Hvn+AtmnegPigGntw8u0aZkBv
         F4iN/B6z+dNz7UftJTF7F/WgCOmmy+iIEXhpJBhCN3UlIf50d7aoyqqbs3j08MlcWIWL
         4L5b5BaI4VbEPBqjhgMEiJl3Ovdirn3yd7RmcgTmliYRTSrYKo+hrDInS4tJMWg9i8eh
         JM7BytRB9y3EQl739ELJyvhhM2u1vGp3Zep5mG5UgS+KWjsGikB2PlW5xuMMsF0tnRmn
         b2ow==
X-Forwarded-Encrypted: i=1; AKwUvBynkcw6Q2eirRCUkNDEQK2ZautS3BKAo4WoCtzDfHjh5MmHFhqnz6toGTlr+00sfcrxgDz6MZJZ1SNbFIU=@vger.kernel.org
X-Gm-Message-State: AFuF++kUBOqtiDhEcD6M/ulYSmdHcu2Tq/sRZGe+KN0iIi0pc55anOI1
	IjRRcn4zAz1vsL+rmuy6PMzV3Zuspb28D33ojfNq8xf+PbtDbUuvkMxhNHjw19eMqqFWrHtQ1jx
	o63WfMHSSke3sT/AHKupBdauaX2EKAKQF/gxn76t6JKGCGIB1mN5LiDmv0pRGo7CBKQ==
X-Gm-Gg: AYBFou20kP3FCpcmz4ruXj42Itc4sd880ntHGpqWGk2LzKe8pm4qZmeluyunihf/Z+v
	/tLVxhboCIDMzUxDZb4Sl90HObjGEGWnOfioyIX/dTp9CtkdQWZXHoWAEhhkp/t0MUXyq+Mh91m
	tEPxgrdPE2zy5g7NVceYbWNcme64Eslgfs4ZzybPhJoe75aS63r6SCJYNhHqlYjMPmJTgFqS6QK
	f+xnAPcJt5rdPeL/uuh03bA2U2be8aNFRUf5tiyA3F6AQRfdkufsM6BorBFtxIOOk+F3/yV6Fbb
	7Nbkuu7VebHw4utGszqXyNglbTZKVNgmccoqa1c8hurPiFJ96LonNR2HOmtr5y7AWwCK3KJtGT/
	pIL2dlj2I8PQG8EKXv0PmHaPBvdNu
X-Received: by 2002:a05:600c:540e:b0:49c:fc6c:be03 with SMTP id 5b1f17b1804b1-49eb732c347mr20435435e9.26.1789555328275;
        Wed, 16 Sep 2026 03:42:08 -0700 (PDT)
X-Received: by 2002:a05:600c:540e:b0:49c:fc6c:be03 with SMTP id 5b1f17b1804b1-49eb732c347mr20435155e9.26.1789555327919;
        Wed, 16 Sep 2026 03:42:07 -0700 (PDT)
Received: from [192.168.0.9] (ip-109-41-176-3.web.vodafone.de. [109.41.176.3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e83fb4d24sm27031155e9.1.2026.09.16.03.42.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Sep 2026 03:42:07 -0700 (PDT)
Message-ID: <97eda9ef-5480-4705-af47-895b2c4527f1@redhat.com>
Date: Wed, 16 Sep 2026 12:42:05 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/11] x86/purgatory: Compile purgatory.c with
 -D__NO_FORTIFY
To: Borislav Petkov <bp@alien8.de>
Cc: Eric Biggers <ebiggers@kernel.org>, "Jason A. Donenfeld"
 <Jason@zx2c4.com>, Ard Biesheuvel <ardb@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
References: <20260813134953.979481-1-thuth@redhat.com>
 <20260813134953.979481-11-thuth@redhat.com>
 <20260814152457.GBan8zSeYlWd_1oWkz@fat_crate.local>
 <7d373eca-c23c-4f79-9391-29d75bd5a53f@redhat.com>
 <20260916022705.GKaqn-eQ9zuCk5tYgR@fat_crate.local>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20260916022705.GKaqn-eQ9zuCk5tYgR@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16/09/2026 04.27, Borislav Petkov wrote:
> On Tue, Aug 18, 2026 at 10:53:53AM +0200, Thomas Huth wrote:
>> @@ -37,6 +37,7 @@ PURGATORY_CFLAGS := -mcmodel=small -ffreestanding
>> -fno-zero-initialized-in-bss -
>>   PURGATORY_CFLAGS += -fpic -fvisibility=hidden
>>   PURGATORY_CFLAGS += $(DISABLE_KSTACK_ERASE) -DDISABLE_BRANCH_PROFILING
>>   PURGATORY_CFLAGS += -fno-stack-protector
>> +PURGATORY_CFLAGS +=  -D__NO_FORTIFY
>>
>>   # Default KBUILD_CFLAGS can have -pg option set when FTRACE is enabled. That
>>   # in turn leaves some undefined symbols like __fentry__ in purgatory and not
>>
>> WDYT?
> 
> I guess... I probably don't care too much about string checks in the
> purgatory thing...
> 
> But please explain in more detail in the commit message what "compilation
> problems" are avoided by disabling those additional string checks.
Thanks, I've updated the patch now accordingly in v4:

  https://lore.kernel.org/all/20260916095022.604354-11-thuth@redhat.com/

  Thomas

