Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189651FA3
	for <linux-crypto@vger.kernel.org>; Sat, 27 Apr 2024 00:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714176614; cv=none; b=gxjwgdZhncFCO2wEtV7hfVGzELhNj1FhohFRGkAHJMqUWRlDhyzSnEH4nbzhfqW68yxJ+F/BfqVqKxDTOwNKADYEbcLNiJNjbKMHkRh0dR006OL8liWKci6BGg8VPpvS2dITZMYzK11pMEbmn9HqQOz/IvZNuFVFNnhDJCYp4J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714176614; c=relaxed/simple;
	bh=yinP9IYiIbLDbM6oDFHQvj2nAf8OvdI9Q9sPTHiIpf0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nVGbPMpMVqJvaOZ5jmCV/TT1q0Wxc++ZNK3bMT9W50soXRZAxQLEmzGL6uTHbB7D+HWUeqHRv6E8uu1I0n+6+y1EM2ntPcEr/1ZOtNn2S2AQc5nWCOYzHX/O9lLaZanI2QZmhfMxmN3vMNyNjkQA6IycANQBBSifZcy6pNcB2+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TNq03HK6; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TNq03HK6"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1eb48c26d14so2140645ad.1
        for <linux-crypto@vger.kernel.org>; Fri, 26 Apr 2024 17:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714176612; x=1714781412; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pX3e6V8dfSE3Gfut3DvSdpkoJdELEXC0BtcZAcuIozM=;
        b=TNq03HK6kSZdc9/5Tb4XtmWpxQoVa2I+AE/c8/xhhRbNvuyref+5AiU46iXNDmWgYR
         c/5zzQV207UtoN7+QarQhMNGhZx9rHLdqfpCxLUM/xBn9Dh2vizqt6bBkTRSF8aZjzYh
         iCrHq9BTZenpLflPCDo4KJV5Ju/f7zVc6O4ddZLfnaSheHL7jxJFKT/NZLH0eKN3h8K1
         QgeLiyS37/18dm60OkKVIhrNyYxq3yyd7w7bMzhCAfl/GU3jT8XGagPCWTFWF+lnWzYC
         fpYnmSz5nVINcHZl67G2gcB1iKOBcEI9nbHikBBEOSxhpQlhztjBxpU+xffGnBcKyWRX
         O0HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714176612; x=1714781412;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pX3e6V8dfSE3Gfut3DvSdpkoJdELEXC0BtcZAcuIozM=;
        b=YxorojosPHM0EHhqqiEqJTdN+9hgP116YO15OVAWdDexkvwyInC2aUHAaQZEuM9iyN
         G9SdJ4x3yqj//nVOiDsL9tbbAL0+xbZUMBPWVJmMTQnnFP3IaKA1OnXo76710Ie8ar/V
         lqpLkrl8r5Fv12+ytjPFMPU1ZnM7F+t+I+wCBPRojEzZ2vQJkrDMTqvxOzAqMyC/h1DX
         wxAExmHKBwqbucfES0QXmsGcOGCNhvyQhPPq1lu3P/SqBrMfS+yT1uNJR4SekvDCidny
         6QSPcfAUFjil+Kc43mvC7r7PkgXmfeL51yj78xfdbt327HchJ0G2RLj5QozVbtBKh7q9
         UoxQ==
X-Forwarded-Encrypted: i=1; AJvYcCU9pt6TOlL3qL8oeTOfZJrAx8CzNRHzO3xB0Z6hHQY0Awd4/kJQPJOywDCc0OCS/cJJe64gttEcFZ7jSJJI3c4N1uczcBIwV7s6MN62
X-Gm-Message-State: AOJu0Yz49ETcrO3BTk2w/E6T2TuZWs2aZjmMym/gpaYIpSnMgaQRwhQm
	Trsy0o1N7yH9wEjzYZDlWxeFQcpj3ucVtc4LU0EnB8S4gatMF+rKWSme+r/si73OgmUtFJ6DFwr
	PpA==
X-Google-Smtp-Source: AGHT+IGeE+8TCHmYAm9ZGbpmSgEKJqEs1Jp1O3g0e+nnHHLhKIoKgjH9RHf12yfFHhvL2WEZcXN4ybRfODI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d4c1:b0:1e5:5c69:fcd7 with SMTP id
 o1-20020a170902d4c100b001e55c69fcd7mr67795plg.5.1714176612367; Fri, 26 Apr
 2024 17:10:12 -0700 (PDT)
Date: Fri, 26 Apr 2024 17:10:10 -0700
In-Reply-To: <20240426214633.myecxgh6ci3qshmi@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240421180122.1650812-1-michael.roth@amd.com>
 <20240421180122.1650812-22-michael.roth@amd.com> <ZimgrDQ_j2QTM6s5@google.com>
 <20240426173515.6pio42iqvjj2aeac@amd.com> <ZiwHFMfExfXvqDIr@google.com> <20240426214633.myecxgh6ci3qshmi@amd.com>
Message-ID: <ZixCYlKn5OYUFWEq@google.com>
Subject: Re: [PATCH v14 21/22] crypto: ccp: Add the SNP_{PAUSE,RESUME}_ATTESTATION
 commands
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de, 
	thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, pbonzini@redhat.com, 
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org, 
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com, 
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com, 
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, 
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com, Larry.Dewey@amd.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Apr 26, 2024, Michael Roth wrote:
> On Fri, Apr 26, 2024 at 12:57:08PM -0700, Sean Christopherson wrote:
> > On Fri, Apr 26, 2024, Michael Roth wrote:
> > What is "management"?  I assume its some userspace daemon?
> 
> It could be a daemon depending on cloud provider, but the main example
> we have in mind is something more basic like virtee[1] being used to
> interactively perform an update at the command-line. E.g. you point it
> at the new VLEK, the new cert, and it will handle updating the certs at
> some known location and issuing the SNP_LOAD_VLEK command. With this
  ^^^^^^^^^^^^^^^^^^^
> interface, it can take the additional step of PAUSE'ing attestations
> before performing either update to keep the 2 actions in sync with the
> guest view.

...

> > without having to bounce through the kernel.  It doesn't even require a push
> > model, e.g. wrap/redirect the certs with a file that has a "pause" flag and a
> > sequence counter.
> 
> We could do something like flag the certificate file itself, it does
> sounds less painful than the above. But what defines that spec?

Whoever defines "some known location".  And it doesn't need to be a file wrapper,
e.g. put the cert in a directory along with a lock.  Actually, IIUC, there doesn't
even need to be a separate lock file.  I know very little about userspace programming,
but common sense and a quick search tells me that file locks are a solved problem.

E.g. it took me ~5 minutes of Googling to come up with this, which AFAICT does
exactly what you want.

touch ~/vlek.cert
(
  flock -e 200
  echo "Locked the cert, sleeping for 10 seconds"
  sleep 10
  echo "Igor, it's alive!!!!!!"
) 200< vlek.cert

touch ~/vlek.cert
(
  flock -s 201
  echo "Got me a shared lock, no updates for you!"
) 201< vlek.cert
