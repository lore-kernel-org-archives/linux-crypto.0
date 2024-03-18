Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8047455C16
	for <linux-crypto@vger.kernel.org>; Mon, 18 Mar 2024 19:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710791217; cv=none; b=RXeGyWnVHaGNq3Kp4eWSVRcOFHOmo9Mi1uZmHV8K8Nk81pkaTB27MDHw1a/ACWZdEub5AWFdei/kt4uh+nBYKu8PBowzFOf4s/+HNXnblaVjTHXWAP9QRfADxPSGXpNQZLlGbdn1NJTZHzoj9rWtLWOot8ZIor0eBTCf+G1Pvac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710791217; c=relaxed/simple;
	bh=QXarlcQFTOfnZ8MEs/XI66pYRHSkWo47OU4szlh2gDw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s1EyUIx/crhZ9agkNQKG514ZU4MQw8gWATkqeEcQ4OGs1A21fvj/42ryJSKbs7cufI5nSkTSGopaUf0ui+KwwLkN355LTOGFXw3pBybRcL85DZpd2b6fLfzsPT+iG+cTanJhmSMl55/RWUoXYsXtyf+mGrLO3GvPXgdaWx80DVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WWf9pbOx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WWf9pbOx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710791214;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2nkUErvEuzOzVX5oKqB7hmMh742gOJKbKSgp0CuYCT0=;
	b=WWf9pbOxrrbh0G6PqwaqMIyB21MNISM/fPs9/3wC5pUYMEQYmXPwSPIDff22ijgD9zFNm+
	i7E9/MVzIx1ydnkZGsfxIwIdifZdaV3eFl18cxH/t2gcQCTjNBbr7TLYUfmgbkALUWP++5
	PRGO2h0XyBx7zOz3QAZhJ4ok3bi5+6Y=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-592-7NEVZ5B5MFWvCsu3FrKikA-1; Mon, 18 Mar 2024 15:46:51 -0400
X-MC-Unique: 7NEVZ5B5MFWvCsu3FrKikA-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-78a087e8b70so135261385a.1
        for <linux-crypto@vger.kernel.org>; Mon, 18 Mar 2024 12:46:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710791210; x=1711396010;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2nkUErvEuzOzVX5oKqB7hmMh742gOJKbKSgp0CuYCT0=;
        b=w7Ko+eX2bY6gPOOnedXbU8ImdW+FmZz7c1U4rkTHgfHV45BhilYe5efdRe23cpma4N
         J9H0Xbje9rSZLEinjXhtUp5tue1EBTvPnOi4EkfSDe8ycIhzFbTH7US053iw7Y7I2dbP
         2haViqwXLBFxsoiZ0zO1iaVL5Ir4v/9PWbulcep5VBMrKj/pAq6JUiZg4FR0qlG4vOBB
         6nIS9Go2CtcUzVmHpN5p2eWsgiSxJ1+c07/a0m9SkF34UcRbj3k8XNz8iLK2fxA3yZHk
         QkQZEwmSk7Y3GOuKGnLG0uAYywOHTqf1wfCbp/6EI+tzJu3+bf4cVMmB55rL797uGqVj
         3e8w==
X-Forwarded-Encrypted: i=1; AJvYcCVr37Dh4DzarMX2Mp+Y9AHjVCBL91P/67YN8nmIqpVQqIOUnqcGDJU+dn0QpISYyl6Xi8nP5bqC3H6uhwZI78M6vTssrtdIxL79rxPY
X-Gm-Message-State: AOJu0Yz6YXVjA88J3vtKKpjUj3LP9lsNXg9vPDXP1rp7nJWuiPokmWiy
	1rkqA51XAA67wvWNCgZLU+vuuUxfd085U8F6BfD5S5CwGL3iAGl71WjsJu7lRJDSFHkaM3UxipB
	4/+90T1yq5V7zLmWKDmdhjqIdlgzqLen7dUC04k8YmP9LAcwEioeMM8nALFCjFw==
X-Received: by 2002:a05:620a:11ae:b0:789:e954:f2c1 with SMTP id c14-20020a05620a11ae00b00789e954f2c1mr973800qkk.32.1710791210610;
        Mon, 18 Mar 2024 12:46:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFCI4FKYiC0L/G0CbsDu9kbD0qr628UZy8bFbruDaWXIMqYx09zyG11dvzViYKjJKN/TgK9Tw==
X-Received: by 2002:a05:620a:11ae:b0:789:e954:f2c1 with SMTP id c14-20020a05620a11ae00b00789e954f2c1mr973775qkk.32.1710791210299;
        Mon, 18 Mar 2024 12:46:50 -0700 (PDT)
Received: from localhost (ip70-163-216-141.ph.ph.cox.net. [70.163.216.141])
        by smtp.gmail.com with ESMTPSA id m23-20020ae9f217000000b007886b695939sm4818943qkg.118.2024.03.18.12.46.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 12:46:49 -0700 (PDT)
Date: Mon, 18 Mar 2024 12:46:48 -0700
From: Jerry Snitselaar <jsnitsel@redhat.com>
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org
Subject: Re: [PATCH] crypto: iaa: Fix some errors in IAA documentation
Message-ID: <cj6rfdhse7lcmj47ux5wba4kfpvjezx7wp5apc2k5gv5gd22ad@fvzpsmxs2ott>
References: <20240318064421.833348-1-jsnitsel@redhat.com>
 <jhpuhcengkgdpgyb7qsez4lugpa5nhjjn3zqehbcbrtr2xh5md@cc3vz7v2xzdu>
 <f6487dcb03a31c35c272225197af87795df2a409.camel@linux.intel.com>
 <hdb2l73guzxz2ck5qbkvpmpfiez646t33ocfqawdgxrnemwrpp@izvr4k6b2jft>
 <64229faa848b78d263a9383f664b0c269ffd65c3.camel@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <64229faa848b78d263a9383f664b0c269ffd65c3.camel@linux.intel.com>

On Mon, Mar 18, 2024 at 02:01:18PM -0500, Tom Zanussi wrote:
...
> > 
> > This is what I came up with last night for the kernel parameters when thinking about it:
> > 
> > 
> > > mode \ default enable | intel_iommu + /sm + | intel_iommu + / sm - | intel_iommu - / sm +  | intel_iommu - / sm - |
> > > -----------------------+---------------------+----------------------+-----------------------+----------------------|
> > > Scalable Mode         | nothing             | intel_iommu=sm_on    | intel_iommu=on        | intel_iommu=on,sm_on |
> > > Legacy Mode           | intel_iommu=sm_off  | nothing              | intel_iommu=on,sm_off | intel_iommu=on       |
> > > No IOMMU Mode         | intel_iommu=off     | intel_iommu=off      | nothing               | nothing              |
> > 
> 
> Very nice. I think it would need a little explanation on how to read
> the table and mention of how the defaults correspond to actual config
> options e.g. sm+ = CONFIG_INTEL_IOMMU_SCALABLE_MODE_DEFAULT_ON=y,
> etc...
> 
> Thanks,
> 
> Tom
>

Yes, if something like this were to go into the doc it would need more
explanation. This was me just trying to map out the different
combinations last night in an org-mode table in emacs.

