Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96AD62066DE
	for <linux-crypto@vger.kernel.org>; Sun, 31 Aug 2025 20:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756673735; cv=none; b=PhEXS5vjqRNgjFE+SDXCS1ZY0vjDyBIhNOhamYApEFvPvTyjwiJ6n8MK0D+ldA9hxxw2XrhltdDjd7VQpGFMestKaglDAtWz269Xb8BsnQ1Nv2i/2iP3JBRzGCCnLEJCvFd/Puk39f+/x5NPi/XMafAS636y2t2L7Z+i7yZOHeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756673735; c=relaxed/simple;
	bh=6gN4kfF9buWX6fhzQlWv0a2QPollAHuzNT/7Og+66xg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gv15/wL1+b7cpLJHpxeERt7ozuWEv11vyugPWdUaYkHvEEhEyzPuWaW4jpF86YV/reEzDsWSK4OiCnz9Jw0R9pyisV6J993/KCLHX26ih/6Up+KIVLGDMYPS4dvM/cojDPmYIgXP2FDNW/e5+CalCQY8MCSZP3/gyUn+RzxYB2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H6xga5n1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H6xga5n1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8ADDC4CEED;
	Sun, 31 Aug 2025 20:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756673735;
	bh=6gN4kfF9buWX6fhzQlWv0a2QPollAHuzNT/7Og+66xg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H6xga5n1D+SquIRFjLvf6UIt9moco8Nl+ANTTVy/Cw2UC8xW605rr5HY39MKEiGg9
	 DXoDFeIb9uNOTkZN7HKytHYN7KdBn6H5W1cNfgdjMEDV9/or8WCbQebXdMEgukYCHx
	 +6UuS5HgOm6hqE2zpkv//1OPn1fxdtOlBiabwYNNhQqNnFJvMD9JHi7CWvHJWmWunR
	 phKSNBw0Ctl3RCqotl4k+KayQi0aiohLGMthCZtubx5iK8cAQYSBc3EhiZ+TdLZsny
	 uxcjekicGyyWRUH4pMS9PE4pi7azI9SlFsywERwT6mfQap6PBsuKjOGYEE2uFWOyJG
	 BH1dsX/TfaLzA==
Date: Sun, 31 Aug 2025 13:54:27 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: Re: [BUG] crypto: shash =?utf-8?B?4oCTIGNy?=
 =?utf-8?Q?ypto=5Fshash=5Fexport=5Fcore=28?= =?utf-8?Q?=29?= fails with
 -ENOSYS after libcrypto updates merge
Message-ID: <20250831205427.GA10819@sol>
References: <aLSnCc9Ws5L9y+8X@gcabiddu-mobl.ger.corp.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLSnCc9Ws5L9y+8X@gcabiddu-mobl.ger.corp.intel.com>

On Sun, Aug 31, 2025 at 08:48:25PM +0100, Giovanni Cabiddu wrote:
> Should drivers like QAT switch to using the software library directly
> to export the SHA state?

Yes, that's the correct solution.  I'll send patches for the qat and
chelsio drivers.

- Eric
