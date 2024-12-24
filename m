Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2251B85FD
	for <linux-crypto@vger.kernel.org>; Tue, 24 Dec 2024 11:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735040666; cv=none; b=ZfaELUgj4pS3yoietbY8w/+rQRKKi6AzVH+0LigFRKnnHjofiqWGyQlQfWP3L/4UdIAZRyztGTIpXfbO2J+gzeybZJuuBoQC6VaYy8xD/fWQQ0vT/vdZtDnaqw/XrlOkGSTZCMXFJRGDt3bCJjFrocoSNedYqj5HAOFxXuHBV7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735040666; c=relaxed/simple;
	bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NqGXah+gp7EwEGXmZE30d7EgAvG1LUdR876RCSMJU9Bt0bwe72/OP6ha1sCUl9s6CUpaW3cw3xWkUP/i/nWNAeusS4l2GWbcWGX6f0q8ptE0SqkxHF1dFIp+1yn9D2yWEyxjtqO/Fu4b0J8iktj1CSy0KSvIMVjMxKx3BUlpNfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-432d86a3085so33150155e9.2
        for <linux-crypto@vger.kernel.org>; Tue, 24 Dec 2024 03:44:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735040663; x=1735645463;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
        b=BlbFxfNovAuEPM8CfOveAoB1Fg/IbpP7lJ/421oC4Q47k4esKU3UcxWhgIZdpa3ged
         xCw2HOu/pQMoJAPsCRJ0Qt6k7Qr8DXDRybH1WeJAo3GspTGroAmRzh9g/uWw9VyBlJgh
         8RaXENLQJNQB+UQuScQS4co1oSjFBv5JO8ppiRS/O9e0o9VE5vmOVsQHGwwh3+iu1d96
         RqV7oaAjprvTelSM3U2BKrhbAxTclE2kg+zvsWgNPHCrQ7OfvHbbLXJGfN3T9O/gJpIB
         7jVvQ+gBD17aKWqH9602bA+FTpdII5CBNWYzmsTBM7GMO2R7HimJnLtjEZb9NtiqIAPk
         t9Tw==
X-Forwarded-Encrypted: i=1; AJvYcCXXwhHCh+3XRZA1kt4GR7BQKmO/AHjzAkJP6BZ+OC0uSLSdJWpz4gcPA/c4nST6ePaFUmzYuyRa6F1xTvk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzP+SwmDw1YlYZYCXKqoyRPn0shiucXKp7Rwyie9r4vRec+6src
	pyJGauPDGXtFmJ3fRCR4pw89lhz/1vGKthDywGzNleREKwpnODB4
X-Gm-Gg: ASbGncu8QqdsyEo1WuMP4yDhX2mfI8yT54WW94iEnvina6WvB7MA9KFBlosAO4bJz+P
	KTXWG/J4tX44vBzwqieJhlT2MX+daJox8HCGpY4+8AHcrlMt4Oc/GjDIw/oLmXB4202PMUJGFN4
	hhtDKvE3rBe6n0oFgjl27CebMej7Tie1+9WjejqHtV+3GgQX6td/NcHqdmZwAR+SKcGo9THHBaA
	eUOViAQ7ZJyYNy9nJwrBl7Kon2M9UVFYuNnq2noyhEzTnwxpXnBVmzX2NHQmSvL9BMSQAINUg8a
	4e+BYg/ZrGk4BiY3fIs5MAE=
X-Google-Smtp-Source: AGHT+IEKenX951wt4ppaePVV7AS/WeqKC7iv4mIRwSX5UXb14WPF8JFi3uoe1rc87S8v5PPTppLHtQ==
X-Received: by 2002:a05:600c:1d0c:b0:431:54d9:da57 with SMTP id 5b1f17b1804b1-43668b78e66mr147708345e9.30.1735040663096;
        Tue, 24 Dec 2024 03:44:23 -0800 (PST)
Received: from [10.50.4.206] (bzq-84-110-32-226.static-ip.bezeqint.net. [84.110.32.226])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43661218f43sm166344565e9.19.2024.12.24.03.44.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Dec 2024 03:44:22 -0800 (PST)
Message-ID: <93f3d0c9-f6aa-44ae-8d86-df813af097f9@grimberg.me>
Date: Tue, 24 Dec 2024 13:44:21 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/10] nvme: always include <linux/key.h>
To: Hannes Reinecke <hare@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>, linux-nvme@lists.infradead.org,
 Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
References: <20241203110238.128630-1-hare@kernel.org>
 <20241203110238.128630-8-hare@kernel.org>
Content-Language: en-US
From: Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20241203110238.128630-8-hare@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
