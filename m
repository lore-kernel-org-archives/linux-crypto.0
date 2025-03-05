Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E384A33;
	Wed,  5 Mar 2025 21:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741209781; cv=none; b=hQ/ERzMFwVd2eXhUC/FMQwJ73C/p76I4UGsNZTX12MsJ+8TnzYyGh2TfqMyZRnHnB00PXe+5p0bDBnmoM29yJp96QjudSyJhvUcf/KSONCIHafKL0JgsBOV0umk+SWGzUJiHffxEVEiNGrcbXojAzzzzzXa0DnbYhSycogJG8fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741209781; c=relaxed/simple;
	bh=71PXLAgsUFwMvAk7XFPttIHq5FqJ5Bzimw8zOdx56eg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TLQxV2f4hPVL4c5eOIyZxvBYNgdj+iEkw9bakb8adMRiAlnhYDi3nXzFMLwzvoSYC2Avvi8LG8A/ayCx0vw4M1/svKd/YlHJbJxBoYLCVXKk7jsebiyjsIlT8YHflOFQPymgDUSstDRYh1W0sNH9j6NdP5ZoJ+Rv0QxMYg6nEeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VWp5Mjaw; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VWp5Mjaw"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-43bc30adad5so25470145e9.1;
        Wed, 05 Mar 2025 13:22:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741209778; x=1741814578; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/QKdrZ9vRb4sWOyQt+BSoKpXoFWTF3y3wSrzqtJFv0s=;
        b=VWp5Mjaw/L8MxD10+azWvfmQdmMAZl0jYn7/9KiABbhMtzxmZrg2cayHrxPRKhA3Y/
         14jz0RlxJO9/OiPjFnDz4kQFtPAReXvmu661MBp04iEpUi+JiYOB2u9aA24kVkPRuAp7
         OZqdbMQ5HRHQBivs53U9XTf5Tc86m5CL7thHEIdy1H8WMWKoawejccCcJrOsffbgBvCJ
         vLuxDxRYlKwvqA5c0bjU5JPwH3LV+m+9VcPqPoaWWi4GBmSWdPW0zklrslfxrOGID5DD
         GJhGv99+rL80cG012JVn+UcfaZXipWmsWeYUit6+7T16n/oetsaAWicTllISGQNF2ke4
         XbJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741209778; x=1741814578;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/QKdrZ9vRb4sWOyQt+BSoKpXoFWTF3y3wSrzqtJFv0s=;
        b=kEuEG6cXphEbopw9Yfb479leaeLLaXzg3j6zWX6grkY75iBT+rYnjvEm4LS8DaoIYI
         9Jqz2RUAw5gAgZRQ29pg8cEkBtf28mDvUEcuy8Xu8SyIoIQSDOls9sJF51phERJfZHXT
         LZv0R3xoNOMOQ3hWae+N5GAACMNKObb2pmAvM7Uc/DfqidtEeKtVvMLpNhH5cn0+Qqh+
         R/3iULOH7QQ5rntoZFr9lcPDPuerB9wAarTT9WIJNrnC9U9VyN5a2h1tM8TzYXipzC/a
         vAkKNyLY/vRXbpAML6Osj2Y51PaPY2AcQuNnDHANHe8pMsYmwvn1h3AFITwrCVnwHXzF
         2ecQ==
X-Forwarded-Encrypted: i=1; AJvYcCW7tWK7M8ie2wqSPL6wIXRa5v6H6HFcJ/cGusJ56S4I9UtzB1tIl9HzJM9Q9iuH75Mf0DLAV0sIsdGGjEw=@vger.kernel.org, AJvYcCWi50BZJMLOTD9aaY3k+ZNoxuLB0jIPDU121y0z//y3MjhXMMTobx3lg3eiFsLJZomyW/Gf5AJzEnerRXoU@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+X99bjnch5du6NrOPyhGaEZdBat1r1Z9pFSR6LQm3bX/MpQjn
	5Bkov338gOEap3CzS7e7SFp9vxyAoZDuks5DvhxYtWEOBRX/ZR7E
X-Gm-Gg: ASbGncvs/RVEKhjBgeqrABxHq5mwQaQYvFWGRKJrA40+169/mlA5rQzql1//tNypo7E
	W7YWa8qY/m/4RWdzpmOZwn1NrfYA5eqnXNa7xd2iYjmoWW0bD7/hDCd9KP4UBUDZS3cg9WXul8B
	tWxu/Eogz3QbW6SJsY1e/96aEXeGNwPZI27KksL2aYNSJmuaDNV2eo01N4NR6MecOp+5Ym/xE+m
	YRQ1iJ8IPd2OMJ7fGeoK2ETE/2Nq05E8nT9bpXoN8nVZ/CrQ34txXhjayisy6fN/Lu+gD7s/xxZ
	7vkjKgwYbE40+5+dPSc2v7B/U3V+je9q4vARNYjO64unWxsScs9K0cd0Zwim+a29a2E037Hf7t8
	lLt4ptoA=
X-Google-Smtp-Source: AGHT+IHf5G/WjTQU5XVggDdiHajuyOu5oqXpSdTcEFetMzqEdhVou5+ChNTWSOmXWX7SGwY1vuK8Xw==
X-Received: by 2002:a05:600c:190d:b0:43b:c309:da4c with SMTP id 5b1f17b1804b1-43bd2951c4fmr42734125e9.10.1741209777613;
        Wed, 05 Mar 2025 13:22:57 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bcc136f5dsm38873525e9.1.2025.03.05.13.22.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Mar 2025 13:22:57 -0800 (PST)
Date: Wed, 5 Mar 2025 21:22:55 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Dave Hansen <dave.hansen@intel.com>, Eric Biggers <ebiggers@kernel.org>,
 x86@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ard Biesheuvel <ardb@kernel.org>, Ben Greear <greearb@candelatech.com>,
 Xiao Liang <shaw.leon@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, Andy Lutomirski <luto@kernel.org>, "Jason A
 . Donenfeld" <Jason@zx2c4.com>, "Bae, Chang Seok"
 <chang.seok.bae@intel.com>
Subject: Re: [RFC PATCH v2] x86/fpu: make kernel-mode FPU reliably usable in
 softirqs
Message-ID: <20250305212255.4989a8ab@pumpkin>
In-Reply-To: <Z8iL1dY3o9OxQgBy@gmail.com>
References: <20250304204954.3901-1-ebiggers@kernel.org>
	<Z8gUYamgBr4M5ZaB@gmail.com>
	<b6a80f6d-8469-429d-b03a-8fa71a33046b@intel.com>
	<Z8iL1dY3o9OxQgBy@gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 5 Mar 2025 18:37:25 +0100
Ingo Molnar <mingo@kernel.org> wrote:

> * Dave Hansen <dave.hansen@intel.com> wrote:
> 
> > On 3/5/25 01:07, Ingo Molnar wrote:>> Alternatives considered:  
> > >> - Make kernel-mode FPU sections fully preemptible.  This would require
> > >>   growing task_struct by another struct fpstate which is more than 2K.  
> > > 
> > > So that's something that will probably happen once the kernel is built 
> > > using APX anyway?  
> > 
> > I was expecting that building the kernel with APX would be very 
> > different than a kernel_fpu_begin(). We don't just need *one* more 
> > save area for APX registers: we need a stack, just like normal GPRs.  
> 
> Yes - but my point is: with any APX build we'd probably be saving 
> FPU(-ish) registers at entry points, into a separate context area. If 
> that includes FPU registers then we'd not have to do 
> kernel_fpu_begin()/end().

Since the registers are caller saved (like the SSE onwards ones)
none of them really need to be saved on syscall entry
(just zeroed on return).
They do need saving on interrupt entry.

For some unknown reason the kernel saves the xyzmm ones on syscall entry.
For normal programs they won't be live - because of the asm syscall
wrapper is called from C.
So I think they can only be live if a system call is directly inlined
into the C function. Just marking them all 'clobbered' would have done.
But it now all too late to change.

	David

> 
> In other words, we'd be doing something close to 'growing task_struct 
> by another struct fpstate', or so - regardless of whether it's in 
> task_struct or some sort of extended pt_regs. The kernel would also be 
> close to 'FPU-safe', i.e. there likely wouldn't be a need for 
> kernel_fpu_begin()/end().
> 
> Thanks,
> 
> 	Ingo
> 

