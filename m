Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48EEE1A314D
	for <linux-crypto@vger.kernel.org>; Fri, 27 Jun 2025 16:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751041274; cv=none; b=aPoqPgEpLRofYQd1lgIQZaGz9vrjugyOiJZJm/7Kvp5bZt7V2+9WZ0esiCPlkIjL+4ZsaiEPgOgh3L5hwb61d9tJAkfrSRIhcOLzZyy8iLZP5XqyglWHoMUP08SVxImn69lHjxPPidOJOtRqQJgIXvH8L6oZgk8pvC/Qr4VBJRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751041274; c=relaxed/simple;
	bh=kIfsRIpxBIjEZgGy1yewd0FLm+0Tpe29DhA0y2vopGE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VgF+9Ppr+nANK8WKPvSmi9nsFsHM5KmL0xmgrrHNDlznHNyoo910nroDkzr6klaiL5KBzrL7JQQRAaF61LCEKQ4jf4Gi+rZhVmrSuYTGboDGu1A1PawtBPnl6HCh+4n9tz9+8HmRb6X6Me+oAlCyQsiXrueyGi/1ILDn6dgC0VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FjZmE8B1; arc=none smtp.client-ip=209.85.160.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FjZmE8B1"
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-2ef60dbaefbso48419fac.1
        for <linux-crypto@vger.kernel.org>; Fri, 27 Jun 2025 09:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751041272; x=1751646072; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0TxxVNL26oR7GUXB2HOXFnes6D6H2mg6+ipOCA25yRo=;
        b=FjZmE8B16apmmJ196N86dLvoS6Vq7m6biLDcyRiy0Ews1AYqXUOo0u4mbrPmOYMhGV
         3+Z8A1unp5H2N5w54w/NGLZsZCbOJf8wZizx75kwifWxwRoR+GrUj7B8yXlMPn3PLTgv
         czRvp6psB0t8s2bKZizL5Bqs52Ovql/+yxtCt3VmVSy+CxwxPIoF+nKJZ9y0QERW2aEi
         +2gztx5cNQiQV1uLzOuZzzhkylAFCb6wa8QgH9tX/B8HQKlL1IGH0lTbepmvo09K+93c
         iLW4mwkCFWF1LQRvQyMjfvJNRb7itwsoFAYfkrMw1v34h8t5xqqPVkhB8bbEe5IBpYOu
         JvKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751041272; x=1751646072;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0TxxVNL26oR7GUXB2HOXFnes6D6H2mg6+ipOCA25yRo=;
        b=JfR9NyskcpiEjadUkWv3Z29q9ZDuwzcSXrlCKcr4SMvDU1hIBkAh0Ngr27q1s9+mye
         1c68K0ttCr+q0XCKrcCLOzCS8urQ6Bmb3dDj6d5H69A7GVDzYxLd9tISkX3jRau5IAKE
         4+S5ew8pY2VQfV/kGMRuUPlqgTWwL3i5O4MSsQZ6YkG/OyAt900zRLGoX8/2gmi+no/k
         J4kLY+Ai+fKg68YOK9AXNr7M8z9d3z7Fy6x8+gO2Ke9ql4TkiquK8zp7enjJji48lhhz
         0qaS1EvZkpO1wRl/fX/s5K5TwbHrCLHLCE0sNW74lXdDj0uZ/p5adCCz6TIKWwZNmnL2
         2WDw==
X-Gm-Message-State: AOJu0YwaE90l0bUPUGzegI8fk+Bb9LEVG/o7U/ptUHehjM5BiBijX6Bf
	FkOe423O+4j+v17JnXwgO0RiWWkwFnROfZebQKlwHxrOmr87+FImGfuofria/Ooa/xqG2pJHdXR
	ZrKSUhYs=
X-Gm-Gg: ASbGncuItNca7Ukr7lhGkQmOBUFUts22CVdag+h4fs5ZXufWGSBppwm1eD0ukNuZZRm
	fNaroG9FxZBsJ1tqtOn/uOBW6LFYdnec+ruLqkqglfoxsNm9ERm+mO5LsJ0gYzww+cK1B7hvAhJ
	WJVcGuSdHLVNvsabPnHM34ZdmnfdLAldg3jXwibvNDF2FA9lBW7MvP8Xis/OtIKktqE1A/KaLBD
	hJhEO3ib21s4x3eUb70SrVW190V5txp6GnrGit4MWYbEdU7xXn/hZoCOvCpOL5mOjh5g35SfD9K
	zsI64pfiaaebZFjhG5QxOyYTqJ/Q080gOoUed7Fweyqk2RrfQ1JposFCsl5erX5D2t+ClA==
X-Google-Smtp-Source: AGHT+IGvSPYJaaamjwff1QhnXbT9ceKRCZcEK5GZBRJhJ3/01bjw3I6uBFo2nvfbS8kkszlyCAPU0w==
X-Received: by 2002:a05:6870:3118:b0:2d6:1437:476d with SMTP id 586e51a60fabf-2efed47939fmr2879727fac.14.1751041272218;
        Fri, 27 Jun 2025 09:21:12 -0700 (PDT)
Received: from localhost ([2603:8080:b800:f700:f3a4:7b11:3bf4:5d7b])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2efd4ea6b86sm950606fac.1.2025.06.27.09.21.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jun 2025 09:21:11 -0700 (PDT)
Date: Fri, 27 Jun 2025 19:21:10 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [bug report] crypto: zstd - convert to acomp
Message-ID: <db35e534-3324-4197-8b94-d6416f713943@suswa.mountain>
References: <92929e50-5650-40be-8c0a-de81e77f0acf@sabinyo.mountain>
 <aF4/r+03iqzs4c9H@t21-qat.iind.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aF4/r+03iqzs4c9H@t21-qat.iind.intel.com>

On Fri, Jun 27, 2025 at 07:52:31AM +0100, Suman Kumar Chakraborty wrote:
> Hello Dan,
> 
> I’ve installed the Smatch tool locally from https://github.com/error27/smatch.git
> on my Fedora 38 system. However, I'm not seeing any warnings when I run it using the following command:
> make C=2 CHECK="/root/smatch/smatch" M=crypto/
> 
> Is there any configuration that needs to be enabled for Smatch to work correctly?
> 

Sorry, this is a check that I haven't published yet.  It has too
much rubbish output.

regards,
dan carpenter

