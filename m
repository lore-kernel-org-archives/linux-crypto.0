Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DBB31C287
	for <linux-crypto@vger.kernel.org>; Tue, 13 Aug 2024 19:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723578393; cv=none; b=ORNbg2xKPuJM3H/HkhES027EIQ+PMeBqBsHlh1udui90FT0gGXxm0Ferts8P0QetEfM9L9a7UPeOnj+UXMjVbWnqCi7WuMHpGLtLj6r3rt8heY1/CK2ftiMLaWaObYENJJ5/QlofCZk8Q/pQW9MKa7pYhOC2z7Ou9g1jqtWJXVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723578393; c=relaxed/simple;
	bh=rRocGnHJo8/qRUOlxEKuDiVSHZgKqgDBtdjhdLRQJ7c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oROUx+SPgEjO9PwuI0gCuBLVkB752/Gg1fpJXsmXiuD60pWrwMYRTtNq+ZBnsKLINJ5nZRep+uRASbTecsPmn34aiNHbx7AU+DzizthZDqHqBDh5pKemQo+rVOkZGrylUlfjOVm2nG7/VF4/0MESlQN230etgmIXqQsvM1g2CXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-42808a69a93so7330945e9.3
        for <linux-crypto@vger.kernel.org>; Tue, 13 Aug 2024 12:46:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723578390; x=1724183190;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D2mWSh3xw8NquFLuGT581tnpK/1OdnahsfBkAptjHnY=;
        b=TBTHkcCQ2NBliJmojwP11ZCtqoAsHcxQ9vhLA1Wn6o/uf31JvSiXE9D4JXKXTCdUsi
         gbQzejrPvgRtigFNKbYWLVqetn8Wd1EFJLfEEbEGhGjiCikAdL59jWccZhDYvOZyJPq+
         ATuuq30CjhDo/4onSflkHiLc8/RZOeWRpb4upWMw/iz+K7ELIaAsXkIWDyQ9d2ck789i
         pySLOZTPsf50rWhpPQZ6m0qAH948YR2ByTvazJVHRgk9/FsGOk8p0YnsTxz1uyQKwXGI
         uTTp3fh6x/7LpISbXsnBuQhzlsrr5v6dr2sLtilARl+V28QQAIG+0NoNqZE63YOhoxE9
         O4Gw==
X-Forwarded-Encrypted: i=1; AJvYcCXB0e8R6TDFkYi5LfRUcbTAXzxjGBBZgi7y34KmmFCZs9PQfyOWEaVpcG6iMI35lJ6Z7/r/LcNHiuBBmpI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzO+uFppGOhSsNhMVCC41J8epMZ1NzcX7zaTkBZgQty2dMabFLG
	k2nRKVNpF9bSf54a/8W2qHZSuCgjAQF+RhrLyYDwuEBQ5TCUWeiO
X-Google-Smtp-Source: AGHT+IGMn2E8XTg7F1a9BWt5dMf6T2kzO8zwpgY2IYrtmNKS459vhAMvbpibBmeItuerYbHZWxU3KA==
X-Received: by 2002:a5d:5f88:0:b0:371:730c:b0 with SMTP id ffacd0b85a97d-3717782fcf2mr264534f8f.5.1723578390151;
        Tue, 13 Aug 2024 12:46:30 -0700 (PDT)
Received: from [10.100.102.74] ([95.35.173.109])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36e4e51ea82sm11221929f8f.72.2024.08.13.12.46.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Aug 2024 12:46:29 -0700 (PDT)
Message-ID: <97bc146c-4f11-48f0-a077-b22f29c5efda@grimberg.me>
Date: Tue, 13 Aug 2024 22:46:28 +0300
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/9] nvme-fabrics: reset admin connection for secure
 concatenation
To: Hannes Reinecke <hare@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>, linux-nvme@lists.infradead.org,
 Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
References: <20240813111512.135634-1-hare@kernel.org>
 <20240813111512.135634-8-hare@kernel.org>
Content-Language: en-US
From: Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20240813111512.135634-8-hare@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

I'm assuming you mean "nvme-tcp: reset admin connection for secure 
concatenation" ?

Other than that, as already noted:
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
