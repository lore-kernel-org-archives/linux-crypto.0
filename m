Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D476F29D26C;
	Thu, 13 Aug 2026 02:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786586477; cv=none; b=i8AQ4lL7DCRfJMIzbckJD3EqZ7d1lfdu9+KbDQhpuv9840TfiqFShOxlDZd+tv+x0OI782h/mQQHjXkRwH3KlYRNxPDFBg4EfML+PWjUgI00eCV7S/+28s64/OR5oy6VSX5dAMeNTd+eJR2+UMUY61ms2pstZ8fg86S8PEaLkbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786586477; c=relaxed/simple;
	bh=q0fsHPJgMyKIvtdbUmgKsJtR9I7fcJsobBWGCSHmOO4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hXWkTG2yZks2QPPymS7uoR3FCutHiQnvGZ6U1jlFKa5t5pPRxtQHI7gRjaiErk7R9cOZT6OVGU7UbR59gh2muD8gfeu/bFkQSzh57Tgnoa8Ms/1y8KlDhqLyf1rPFDm+lRt/wjUEkZbNn/YzYsmKfZp4BOGodTGCIYvK9q67OPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I8+6EBmD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I8+6EBmD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F871F000E9;
	Thu, 13 Aug 2026 02:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786586476;
	bh=A7hjQTcuVZ4M0U1GClWWJFjbMC97OmNQGWCTpYj4NKI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=I8+6EBmDAQOt+Jw78rRECxyQK1kV2ZtVw2m4wXX5cHHslFUhprUecZRjWws/5mNpZ
	 /9JGQW6qJktyMYI9YDqA/J4MutZVtQo0ytaBM/tKB/a2tx14F8ShJskcLcaBOWIY0m
	 w4uaud/7G6h6s4J6VwlfDzdffgsj+4FsgsoIVTQSZGksgfsqUOdP/tM1aT9hjNIM8M
	 JbnvGn9nLaOQvW6z0gL0lSuLvOkAGkY9GllzYAen75dx2RuNbkWutGT+rvZj3ivoUK
	 ZDxRk/i1IaLto2xDsT4IXLWgzDLW6sW43vvx81CfH7asR1LYaOw4VNTbZ+1yN7L1Oy
	 rVrVJWQ4u+lvQ==
Date: Wed, 12 Aug 2026 18:59:13 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Thomas Huth <thuth@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Steve French <smfrench@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: Re: [PATCH v2 0/6] crypto: Add __cleanup functions for zeroizing
 aes_cmac_key & aes_cmac_ctx
Message-ID: <20260813015913.GA28329@sol>
References: <20260807125845.1477067-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260807125845.1477067-1-thuth@redhat.com>

On Fri, Aug 07, 2026 at 02:58:37PM +0200, Thomas Huth wrote:
> Code that uses AES-CMAC might need to zeroize their local aes_cmac_key
> and/or aes_cmac_ctx structures after use to avoid leaking sensitive
> material on the stack.
> 
> The first patch introduces an aes_cmac_zeroize_key() and an
> aes_cmac_zeroize_ctx() helper function that can be used with __cleanup()
> to automatically clear the key and context when they go out of scope.
> 
> Patches 2 - 4 add the __cleanup markers to spots in the code that
> missed to clean up the structures so far.
> 
> The final two patches are just cosmetics and change some memzero_explicit()
> calls to use the __cleanup() way instead.
> 
> Note: There are more spots in the smb, tcp-ao and bluetooth code that
> need some zeroization of sensitive data on the stack. I will tackle
> those in later patches, this series here focuses on the new __cleanup
> wrappers.
> 
> v2:
> - Update comments and positions of the functions in the 1st patch
> - Also clear tmp[] in the bluetooth patch (the patch is pointless otherwise)
> 
> Thomas Huth (6):
>   crypto: Provide wrapper functions for zeroizing aes_cmac_key and
>     aes_cmac_ctx
>   smb: clear the aes_cmac_key and aes_cmac_ctx when done
>   net/tcp-ao: clear the aes_cmac_key when done
>   Bluetooth: SMP: clear the aes_cmac_key when done
>   lib/crypto: aes: Use _cleanup() for aes_cmac_key instead of
>     memzero_explicit()
>   mac80211: fils_aead: Use _cleanup for aes_cmac_key instead of
>     memzero_explicit
> 
>  fs/smb/client/smb2transport.c |  4 ++--
>  fs/smb/server/auth.c          |  2 +-
>  include/crypto/aes-cbc-macs.h | 34 ++++++++++++++++++++++++++++++++++
>  lib/crypto/aes.c              |  3 +--
>  net/bluetooth/smp.c           |  3 ++-
>  net/ipv4/tcp_ao.c             |  2 +-
>  net/mac80211/fils_aead.c      |  3 +--
>  7 files changed, 42 insertions(+), 9 deletions(-)

Applied all except patch 3 to
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
