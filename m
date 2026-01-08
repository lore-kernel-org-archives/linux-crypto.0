Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624F02D94AB
	for <linux-crypto@vger.kernel.org>; Thu,  8 Jan 2026 15:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767886944; cv=none; b=GB3omeJBq/zmpmBRIhdajQREALNPyTeTue9cRJ2L/C65ikqxaiQjRAQSnT39Zn9ysUWpIk27yGaY0XBbJQ1Lfz7ZeB6Gl7gAgQtRSSXTMMU2iITFmGFsnVBbu/a1HhhS2u4t3Ex9bOfH8pwk7ZlWE9IRTUoEB+pdLEIHzzouzx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767886944; c=relaxed/simple;
	bh=ZEg3oQJaVSZ9gyf64NrqCt6gf+xa+Xosp1a/kSE2/LE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=bqtGDBM6RAyK/55EPYgyxU4wBRr+sF2+Cyvui7BSZyd6/4pzAwPBsKV25vnFrkYgJ3/rvraIqNipAMANOZxU8BIv6LZ2eKlpgJLSHaSR17CtrOvMj+egunxflMEq2Qpho3xGArM9xXcz6VeIYbaZ3lVpbBWX/UNbQoPWvl7wYbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Wxm4TtQ1; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=riDIt35j; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wxm4TtQ1";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="riDIt35j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767886942;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZEg3oQJaVSZ9gyf64NrqCt6gf+xa+Xosp1a/kSE2/LE=;
	b=Wxm4TtQ1GOl+VCH9bFbrtxuNpJSdHojluOlV5dRfZIhrYs+qu9uM5tQcaaAGLUfpbVrTJv
	+SweNUz8k0F2YAUG5mbOLLf8TtSYvFaii3BUPqJuSdAg5c6/ZSH5AHueTQajTOlTbCO0ck
	0c+ZWJB19U7IQ2ZPhi4gvGBIGE5hoKM=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-180-c8q2L4YIN-OnJFmyNF1rgw-1; Thu, 08 Jan 2026 10:42:21 -0500
X-MC-Unique: c8q2L4YIN-OnJFmyNF1rgw-1
X-Mimecast-MFC-AGG-ID: c8q2L4YIN-OnJFmyNF1rgw_1767886940
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-64d1982d980so4351007a12.2
        for <linux-crypto@vger.kernel.org>; Thu, 08 Jan 2026 07:42:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767886940; x=1768491740; darn=vger.kernel.org;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZEg3oQJaVSZ9gyf64NrqCt6gf+xa+Xosp1a/kSE2/LE=;
        b=riDIt35jOyvWopvNnOSj4H68EKyzfApCbkIL/L+s7aLD+nnVweGVb/nqZTXKYoRLpt
         kb/MdCMO7wjZRpRlcmQKewWmi1cRtKXpcFEBUOWEDXIa+LEWrtJr1TNo0gvxmI5P0aDx
         F23e8+vgwKVLXfUC7xoLeNtntxQj2ZjQ6zx8w/+0S8VIc4Oxf6rmQCfuE3zDVdA8PKlN
         KOcIRWx+wVaY3O9sJEVHBuBBeQzglgFOSdGOhFjs8PSOIT+RIjtgdQOtyyE3alDtWmED
         15kTFyn2xrryVdvl+FEKjLTT4eVbc4tfruCHosVS0IjjS7JGmcgJz6LKV28WL4iZ51HK
         mx8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767886940; x=1768491740;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZEg3oQJaVSZ9gyf64NrqCt6gf+xa+Xosp1a/kSE2/LE=;
        b=LWZSSzIVFvZc3KAV8fNNFrBFsFdpGXA6qZEhkuvZYbziraOgyo4h+vX9E4yknFhWim
         AlrrfDKTIyTgR7/cW2R33Oe8Bb6YdmKqzk53eiceoHVKonO6Qv7bwwyMOvwJJcCpTfo2
         62xRBOHLmamO3NifUdvKrBX31mzf9/lXkqA6wY0Yv6u2RfLTWbHCpO75pIKWNe9tzvFw
         tgnO+bdvhKixVMfKi22f3c++MvvchLfPjXgAwWpbIQuRiyvUOR3dEIC+RY7j+zR1ybWD
         QUx3zue57PGAu1hfKfwhKAJb3P8iInF6yOHEHvyzB0ubtJzEGngKO/EFbsG8s3GKXij4
         80xA==
X-Forwarded-Encrypted: i=1; AJvYcCXCR8k8SCiMotel82ZRMGL8hjpQ9B0MZgvxK7DaVdA/wpVAR8gQNL5xyaSrpztthZBkoSEXbA334ekNHtM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6E5ey5qMUbV9dXcV+nqqQVo7W60Vp71LXPkqr4AX14GrvwWBM
	qSGvbFRYdyNLNrZD86VfyU8EAZOTGHGTLZXB/RYKZMbtp+K/xePDPrTvAtTkfvs9gsuMrjBz9G2
	PDPjZMlA42ZOZ1qfbtPSoj5IBEEeu31ucWxXO2eHnrH1+SouQeWAIalXbaxgBylgyLg==
X-Gm-Gg: AY/fxX4LgXufetmgQRI/dgtNeKxdqrDx6y9jdIfHkLjx4+KyVqtl3wMjlC8BvKwCxue
	TxH2F0d/IeRiVY8B3Cv4pFOnApv96How3pu1KdmZo3AVqoQ0n5ixwGrjBLDYx2oZeiICFrZwXTp
	Fd+MIih5CE7u4TPR26NCjq1rKX1/F7lybsvbKqI79nsj+dQcpXSIC/zuPJgAkXMIekRhMi9znjG
	CQGSdYMhCzkI1X4087DGyHIUrx/0J8rENS1Yd0GX6/2ZMX40YRp6PzIgZsPOgrWi83kXVHMVQAL
	zoVKGjQDGWXapc4UNovtdQuP9r0xfxxrDn7KNeAm4D/8UMaA9SiYoFWK9TCICK5v8vEwIHYSSG+
	2hPoSqlnNZ6ssbKPU0Yqr7MZNl4ywiXbrWQ==
X-Received: by 2002:a17:907:97d3:b0:b76:4c16:6afa with SMTP id a640c23a62f3a-b844520d854mr673248866b.28.1767886939980;
        Thu, 08 Jan 2026 07:42:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFEmzm9ojkdaouBuECH5ouH3ZkOr606lOqHVp+y6UkQhX2c6rO2xuikgZvCygfJYLp5GDnXHg==
X-Received: by 2002:a17:907:97d3:b0:b76:4c16:6afa with SMTP id a640c23a62f3a-b844520d854mr673244966b.28.1767886939218;
        Thu, 08 Jan 2026 07:42:19 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b842a51577bsm822611466b.56.2026.01.08.07.42.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 07:42:18 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
	id EA652408391; Thu, 08 Jan 2026 16:42:17 +0100 (CET)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To: David Ahern <dsahern@kernel.org>, Eric Biggers <ebiggers@kernel.org>,
 Stephen Hemminger <stephen@networkplumber.org>, netdev@vger.kernel.org
Cc: bpf@vger.kernel.org, linux-crypto@vger.kernel.org, Ard Biesheuvel
 <ardb@kernel.org>, Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH iproute2-next v3] lib/bpf_legacy: Use userspace SHA-1
 code instead of AF_ALG
In-Reply-To: <e1fb9a40-9580-4c6b-8272-2d306a581cd1@kernel.org>
References: <20251218200910.159349-1-ebiggers@kernel.org>
 <e1fb9a40-9580-4c6b-8272-2d306a581cd1@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date: Thu, 08 Jan 2026 16:42:17 +0100
Message-ID: <87h5sw2js6.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

David Ahern <dsahern@kernel.org> writes:

> On 12/18/25 1:09 PM, Eric Biggers wrote:
>> diff --git a/include/sha1.h b/include/sha1.h
>> new file mode 100644
>> index 00000000..4a2ed513
>> --- /dev/null
>> +++ b/include/sha1.h
>> @@ -0,0 +1,18 @@
>> +/* SPDX-License-Identifier: GPL-2.0-or-later */
>> +/*
>> + * SHA-1 message digest algorithm
>> + *
>> + * Copyright 2025 Google LLC
>> + */
>> +#ifndef __SHA1_H__
>> +#define __SHA1_H__
>> +
>> +#include <linux/types.h>
>> +#include <stddef.h>
>> +
>> +#define SHA1_DIGEST_SIZE 20
>> +#define SHA1_BLOCK_SIZE 64
>
> How come these are not part of the uapi?
>
> I applied this to iproute2-next to get as much soak time as possible.
> Anyone using legacy bpf (added Toke in case he knows) in particular
> should test with top of tree.

Hmm, not aware of any users of the old code. I believe most distros
build iproute2 with libbpf support these days; that's certainly the case
in Red Hat land.

-Toke

