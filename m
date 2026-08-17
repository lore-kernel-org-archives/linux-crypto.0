Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E4D3E5A37
	for <linux-crypto@vger.kernel.org>; Mon, 17 Aug 2026 10:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786964131; cv=none; b=adAsgNdlSqE/yJnSQVWsn8dF5tM4kZWJxBDdkJRJBAjjj2KxkhUIJhFNwJmnCdx6D35+/yO61jPlUQDLa6iNfdnCE/omUSpGCZvXmYWz1f/tkooWI2/44T8pbtqbvTJAnK+o1nPW3RYxll5omZf/msQ9FZLaKo9arMyLM3gzJEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786964131; c=relaxed/simple;
	bh=oY/WPxJ7Hk/heY3LL7xfbLbJFoxIPUpFgoVBsoCjkik=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=StgJrHpG7B1rDkhrB4Wqog8WBC5O8CovXrbaPhqQ0bP6BNfyfEbhctQ+hySHZu1aByKmgrK0gZtYr12lLvFj/c2xjITpgxS8OqV6iFG7xkp8d9Ihi+R5+4HSjmaJIWlx9qU3U2EJZJrWIhlGTIVSdy3j73CPmGtEwN84cJ8oSRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X+ae67ja; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X+ae67ja"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4998e0916faso15430395e9.2
        for <linux-crypto@vger.kernel.org>; Mon, 17 Aug 2026 03:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786964126; x=1787568926; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9LRBFBAtx27EuSLkwrHlog8l1cdy3L7iJ6s4HbjypDE=;
        b=X+ae67jaemIqlvGRxEXGRjtoWXSQ14jiNnDwYE9NAPWNFQDKhzZa2BvbxmmHswmKMQ
         EEhiTg8IcAqu0H0skHDlhh7gRdn3eXL+PxTiO9vdVr/zI9901TSD73BmT3Hxz7Nd3gcu
         LOdhzz2ez3OMG/YDdRoioMNVEsa7lSWvaLNGxL9yUbXQX9CJDZ58kf82zqsqtZ3z5sbP
         1k1LvLPD885bjZTCRom1hc4vmnEMUw9/5iPmni17EVSJ64vPIT0uYCKXvJuhCOpiIri2
         xiOx0hutDe50dbC0tB5/VH9k1rFyFXkc/L05viA5lU32Dq8cr/uXP9jgVaduSXb/5bUT
         f0+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786964126; x=1787568926;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9LRBFBAtx27EuSLkwrHlog8l1cdy3L7iJ6s4HbjypDE=;
        b=oe1GzHIaku7GVM3fv7op7UEehdn0E297WFaYs2bDUhYLsk34LsaiLO/2M1svqs7nl3
         VsBiGZNyCAReTtWlMNhoO3NTnqa3RGlUo80z0bNYTojv5IJWSuCe6ZDu468Cgn0SsSYa
         Mhxedfgy4+yXwHxLGrqjKIGhWi2umhOswX31Ko4DnBGBXuY1OrAFnvjvlNBm8It12L7d
         A0Xw6DuXE7bYDiFW4Q04XBn+hWvURbmiIZSKaXaiTk5+rOolWyiYPLAZ25aLyxe//+Fq
         kD3JeApx9txoWba7XbX9mSCh3K+vmDZiPopHhLqrjuPrgbTGBpOCpo4CY3lazttpdgu0
         /Frw==
X-Forwarded-Encrypted: i=1; AHgh+RqdSoX4yGNNZCWSHMkFT5umNX8bPDasreu36QgvQb3ldbIOMDIA3xj18Zrpgxf3/Tk5Gvp8MHGJF/Mo8Ek=@vger.kernel.org
X-Gm-Message-State: AOJu0YydMh8L2Bkk5JBjdZ+YH9/qb3InsRKXqRLhT/b2HFwa/UUhArl8
	SGeph5kZDo4b1lp1KjgrUgzraGUY6gvF4CojOBugnHeX+KJQrBs4bM98
X-Gm-Gg: AR+sD13IjdI+lnzAughelEAphkLmwSaNe0GqSiJqiA1CymF4k1CAvX9eQhNNpuFJ/A3
	JbbfxCCn85YCZb+4+FhkoOXJlYQuEstgk1TR42P0kToAbynUbsoj70qJ9f7dj7PlhiM9UkyB3k8
	pwzKTGi/R83VH/qaPjlhsxB6pfATyuX/h0uFDdfmQiUKl3aFMom51j/aSgZ+rqflbFI8gGlWRme
	e+IPHEqst8gwQKvpksCrTwaUMx6olkPrzHNnxs9KnrUHdFkJRDza7usHSJNjRalMEs/nT52p5Qz
	eM9xU50deiGoEJKvoT4KlewUjzVqDKgUvgQXpXPvB1UR8eU9goEWO7KqLitcE+97AGTuhPVQewH
	ZRdBe+CjDyCp58MXQQz28VEGXurLuOTXAFyn/N+h/0PwrK18um4hz1eTIfYF5rHEvngby752dj+
	yZG/Xl4erSyOFEWQ4oE4BLce1kpsiSYMptl/OyJiglf8OZoXazbv05TdCd+y8M+bnlSNxnxcjcH
	hOEecWzIpRz9fshCmDijYpvyA==
X-Received: by 2002:a05:600c:628c:b0:499:87f3:a2a3 with SMTP id 5b1f17b1804b1-49987f3a33emr415143305e9.15.1786964125514;
        Mon, 17 Aug 2026 03:55:25 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499961098cdsm157881145e9.6.2026.08.17.03.55.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 03:55:25 -0700 (PDT)
Date: Mon, 17 Aug 2026 11:55:23 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Biggers <ebiggers@kernel.org>, x86@kernel.org,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 Taehee Yoo <ap420073@gmail.com>, netfilter-devel@vger.kernel.org, Pablo
 Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil
 Sutter <phil@nwl.cc>
Subject: Re: [PATCH 0/6] x86: add missing vzeroupper instructions
Message-ID: <20260817115523.7c6c646a@pumpkin>
In-Reply-To: <aoLRJ7igR5GTMfuO@infradead.org>
References: <20260815205750.169336-1-ebiggers@kernel.org>
	<20260816161450.05fd24f2@pumpkin>
	<20260816173159.GB2013@sol>
	<aoLRJ7igR5GTMfuO@infradead.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 17 Aug 2026 02:15:19 -0700
Christoph Hellwig <hch@infradead.org> wrote:

> On Sun, Aug 16, 2026 at 10:31:59AM -0700, Eric Biggers wrote:
> > As for kernel_fpu_begin(), no, it doesn't do vzeroupper.
> > 
> > I do think that some years down the line, we'll drop the use of SSE in
> > the kernel entirely.  At that point, vzeroupper in kernel_fpu_end()
> > would make sense.  
> 
> Or add kernel_avx_{begin,end} wrappers that include the vzeroupper
> in kernel_avx_end.  That would be a lot easier to use than the manual
> vzeroupper in every modern user of in-kernel AVX.
> 

You might want one in the start as well.
I have a theory that the avx512 logic was added as a completely separate block.
This meant it could be included in cpu for testing but disabled in any
released to customers.
(Or maybe the it is the original avx logic that used latches not in the
normal register file.)
A side effect is that different latches are used for the low bits of the
registers - so when you change to/from avx512 the register contents have to
be transferred between the blocks - adding latency.
So if the wrong registers are live for the code you are going to execute
the data has to be transferred across.

There are also other effects as well.
I found this link: https://travisdowns.github.io/blog/2020/01/17/avxfreq1.html
It is a few years old now (2020) but probably still relevant.
A quick summary is that the first 256 or 512 bit instruction starts a 9us
window where the cpu runs at 1/4 speed, for 512 bit that is followed by 11us
where nothing happens at all. 

	David
