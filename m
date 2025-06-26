Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07CA91CAA6C;
	Thu, 26 Jun 2025 17:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750959318; cv=none; b=FG94JdoAqoiqg8QL9mvv31aCPv/H0/6UeGuikNqJ+1pQ4DDuZW/UqiVoRW6cMODGkmIuBJ00XtZFIuEWP0136lNvFIc4G912vkIHL5UskmQkUjkK4MrU6s3X4txeUIbFo/MKUdsic5XEpKehlc8yUzDU5Ul/HovG9Vx5UyUHj3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750959318; c=relaxed/simple;
	bh=1GIjvQVTxNOLiFLtq+fHFUGhsTLzHfwQloFVX0FsByA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XZ8tKAn1TQE6e0L2WuqF2rOREKABBPdvFSeCalwOOOH3g/Bxk7kd3UA+w1K0QRXcrFkqKD64OIsBLqAL2zbCCC1/RxSzc4jSnv81HE6Wu9h2+DaUEolLOQ2iSuKyZqp2eWE91R80WxLKO6H7U91Vz0p/GbL8CITEZiJBO32xDwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MrmKpNdN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MrmKpNdN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7030AC4CEEB;
	Thu, 26 Jun 2025 17:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750959317;
	bh=1GIjvQVTxNOLiFLtq+fHFUGhsTLzHfwQloFVX0FsByA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MrmKpNdNjDNPNe5cAe/XByrc6bjqVYx7e3ld/6d+xRbehXSryZ2Li9YyngTNMtaXj
	 DoD5j85QQYieZEFzoF6IwpBtsN8TpG/b6X3olBpNQQIxoOTgdxF2UFuE5z85FVRprX
	 G+hNf7vdd5THGhy5vhxksNGDohbIGX2/3/yQKqI1y5vWNTGf7978s6d99c7rBYgd2n
	 lGxKSBtup7M4o7DeqmHda2JO/nt4FvjAJ6L1N9z+Rw4X22ML4H/EdUyWg5QT8izogv
	 /RGiwQcWYHAjt+u0vG2KafB+eW9fTnOGFGnfImGaqP9pHRHALDh+ogzo9rOi9QjAg2
	 rHQIK7iMg17/w==
Date: Thu, 26 Jun 2025 10:34:41 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ingo Franzki <ifranzki@linux.ibm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: Syzbot finding: invalid-load in arch/s390/crypto/sha_common.c
Message-ID: <20250626173441.GA1207@sol>
References: <12740696-595c-4604-873e-aefe8b405fbf@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12740696-595c-4604-873e-aefe8b405fbf@linux.ibm.com>

On Thu, Jun 26, 2025 at 03:54:58PM +0200, Ingo Franzki wrote:
> Hi Eric, Herbert,
> 
> There is a Syzbot finding in arch/s390/crypto/sha_common.c.
> Yes that's s390 specific code, but I guess its due to the recent changes in the digest code....
> 
> Seems that field first_message_part (bool) of struct s390_sha_ctx has an invalid value when s390_sha_update_blocks() gets called.
> No idea why it could have an invalid value, I only see it being set to 0 or 1. Maybe ctx is pointing to an entirely wrong context in that call chain (bad pointer)? 
> 
> Does this ring a bell for you? 
> 
> Status: reporting: reported C repro on 2025/06/09 15:22
> Reported-by: syzbotz+cb049f03e0851197b31a@linux.ibm.com
> First crash: 16d, last: now

This is an issue in hmac_s390_sha512, which I haven't touched.  I see there were
recent changes to it, though:

    commit 89490e6b80c53bf7783fe183a2fda8d0944f52d2
    Author: Herbert Xu <herbert@gondor.apana.org.au>
    Date:   Tue Apr 29 16:49:32 2025 +0800

        crypto: s390/hmac - Extend hash length counters to 128 bits

    commit 08811169ac016a234765e23deb45a5c8dd8aee6b
    Author: Herbert Xu <herbert@gondor.apana.org.au>
    Date:   Fri May 2 17:00:43 2025 +0800

        crypto: s390/hmac - Use API partial block handling

    commit 1b39bc4a703a63a22c08232015540adfb31f22ba
    Author: Herbert Xu <herbert@gondor.apana.org.au>
    Date:   Fri May 23 19:24:34 2025 +0800

        crypto: s390/hmac - Fix counter in export state

- Eric
