Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7576742AB7
	for <linux-crypto@vger.kernel.org>; Sun, 29 Mar 2026 21:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774821428; cv=none; b=MO5enKhi9Oi9ICVhX5lWSzTb9gKmmC+QJ4IJCLaCJYQhXV7nojOo5oEAkVe/NyzISc3RF+ZlywwZP9nFpROtU7SShXinoG4VOd0cUn9VktyI/VmqDpwAP68UyvyqX22Vef1+/Xcpq2QR20zEuy6GXkRTGohsGt1xzHjRfKI3Png=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774821428; c=relaxed/simple;
	bh=WnfU5UGN+TVTG1dIBUcOpKv+B6jRulWifk7HcxeXPHQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X1uxGAgXjLDimMdShOy2UToMQJqTn+l3wBFfFmdRLSRSPwPQp5ry85fmXmVBScQP0EUgMp+/4gggDSuwO4ux0Bndv4Yb8LFII0U5SSjsOJ5cP7ArOyi7WlEDwyJ2GOE74cWRCLL5woaMBEHhKF60nSkFy94E7tKsgKZzGenSS04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lmp5AdmJ; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lmp5AdmJ"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-43b7481f9d3so2066283f8f.3
        for <linux-crypto@vger.kernel.org>; Sun, 29 Mar 2026 14:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774821426; x=1775426226; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/PPpHwpK+XhWFnGV+Za6xJpLzu8J3tufoqK8mJt5f1M=;
        b=lmp5AdmJR9l8tPsZTiuNS6f3uQKdC9KB9eYIlgzkwuix9rYyqhIGpClT9zUP/IhZFO
         DrVUagNIT09oIP4a8TIvGf/8vl0dHhbTBM4EPQSqdrIu5Brm2AfQ2TG/Vex8s24AOQiT
         XCmCYzF/G0HR0Q7xmrEf6oIXWsLlcks9Y3sxL/XFNL+/zkhBnIbHDoOk/NhxE68zFoST
         iDxVk2eB1nIfLHLI3OkrzWsTsXWznz8NKnVJNcq8DxJkpfQSl7xesBecRpSw83tXpSz/
         gWZhDv1cjFF0UqLv+ybSoMSM8+AGzrlVvsZ6xyn7z/EVsL+iLbHcNyQNtabWcOfG7GIm
         eTXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774821426; x=1775426226;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/PPpHwpK+XhWFnGV+Za6xJpLzu8J3tufoqK8mJt5f1M=;
        b=JViAw0TBnURfcvAMk9ymloPpvWgVOTT/Xfo/oI47ZOsC2C3njBCJ5I+bkN4LfkIyQ9
         SD5B3L9Ma87IFfcVPQPoXq2H7le3U0Pbughj3803ouJ9R90AY7GZQBSYav9Po99grKRK
         15RLCQWUj4Qv+s+nN8EjaEoWpgUj2/QBVMnJ8XVMda7mwUspGLFQWZdSt+PPiq9/Y15n
         woJNbLd8++V8ER6tdCBaPu58hMt/0aru20Ar9obNRJ2LOj5G5dwQp0wFPKCgdYJ9WEcT
         exhRtXvVNP86lvjphqu2XDo3VUkQEpIGvOJoJagX+L0qopdBe2BbdmDTBcKPgH7rUgtH
         xWXA==
X-Forwarded-Encrypted: i=1; AJvYcCXRevxZ6V/icwUgVE7SsxR5TVvCe8A+/XXln8g98K/ine0W7Z/6CaU59jPRD7jSMv1b2dvc+cHeLEoPrv0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLdpj/hLGpX8cGY/nhmQVBLv2DeY/vce4LWze6+ThamEKQ8UNr
	doIxYPI/9hVCizy08gdHRFqefiKw+79bnO4nVnVd1XnfwqcbpQ0tNjm+
X-Gm-Gg: ATEYQzxHsgODYMjyKLD7g657FgbJWZ1KkhDli2Zy5bIjP8ElsLkhthRQHwAhV+uQFFr
	L6RtP9Ecs5yrveIBo/W8y6VvlLpH+erBiGt7/07tleqL+TFEUtDvTb/5lGHcIdJID4tqd9RTwfc
	a3fj8fhcpRVaKs0r2ZhIVnC7zmhxPnS13Zt072gMJZ4NQTUTKi0a4YJNV3QNASNMGxTsPZO4c67
	djeQqts3tW1pMnX3asnxfQyOvT/TWwFUVoEcEpfodfD2Oo4YITyFTpNY0q14saxslPjC5l+kbRr
	18KTSrljgaGY/VudtNEPp+M8L36IeLAhty/P76qpK3sgz5pCpxXev4Vxei2sbSpuWCgAl3SLw7V
	Php+p6iW1u+PfDyQJsyXHtM567/fN0Fe5XsCEUjUBeVaeeC0BqEXYIeRiJ4+9l2fzm8t+uE/bzM
	vkDjizkf5fil10BmkRALG3sC+fZPWscdv/8s/dIAncPhaXyIxJmXieQh90mLP90Qlp
X-Received: by 2002:a05:6000:400f:b0:43c:fdd9:188f with SMTP id ffacd0b85a97d-43cfdd919d1mr3533554f8f.23.1774821425608;
        Sun, 29 Mar 2026 14:57:05 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43cf21e3602sm14596947f8f.4.2026.03.29.14.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2026 14:57:05 -0700 (PDT)
Date: Sun, 29 Mar 2026 22:57:04 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Demian Shulhan <demyansh@gmail.com>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 ardb@kernel.org
Subject: Re: [PATCH v3] lib/crc: arm64: add NEON accelerated CRC64-NVMe
 implementation
Message-ID: <20260329225704.0eb82966@pumpkin>
In-Reply-To: <20260329203829.GA2746@quark>
References: <20260317065425.2684093-1-demyansh@gmail.com>
	<20260329074338.1053550-1-demyansh@gmail.com>
	<20260329203829.GA2746@quark>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 29 Mar 2026 13:38:29 -0700
Eric Biggers <ebiggers@kernel.org> wrote:

> On Sun, Mar 29, 2026 at 07:43:38AM +0000, Demian Shulhan wrote:
> > Implement an optimized CRC64 (NVMe) algorithm for ARM64 using NEON
> > Polynomial Multiply Long (PMULL) instructions. The generic shift-and-XOR
> > software implementation is slow, which creates a bottleneck in NVMe and
> > other storage subsystems.
> > 
> > The acceleration is implemented using C intrinsics (<arm_neon.h>) rather
> > than raw assembly for better readability and maintainability.
> > 
> > Key highlights of this implementation:
> > - Uses 4KB chunking inside scoped_ksimd() to avoid preemption latency
> >   spikes on large buffers.
> > - Pre-calculates and loads fold constants via vld1q_u64() to minimize
> >   register spilling.
> > - Benchmarks show the break-even point against the generic implementation
> >   is around 128 bytes. The PMULL path is enabled only for len >= 128.

Final thought:
Is that allowing for the cost of kernel_fpu_begin()? - which I think only
affects the first call.
And the cost of the data-cache misses for the lookup table reads? - again
worse for the first call.

	David

> > 
> > Performance results (kunit crc_benchmark on Cortex-A72):
> > - Generic (len=4096): ~268 MB/s
> > - PMULL (len=4096): ~1556 MB/s (nearly 6x improvement)
> > 
> > Signed-off-by: Demian Shulhan <demyansh@gmail.com>  
> 
> Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=crc-next
> 
> Thanks!
> 
> - Eric
> 

