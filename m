Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793059070;
	b=w3BJFQg98yLzvjqqyb/j7x0muCBloHwNw3flRmuKJnWWktlAQ+fIdk1tFB6kgKxJ5toN
	 8mbDfUnbLd4r3+TMCEU+MLSYWpJ1SafIWjt6RYRMClD9yl8evAnoW3WmjRBVTAaFHz59Q
	 sBRHa2HL3Kq6JdPVypCOIv8DkZTcI4iEL3gMLRDo3+TjN3i/Ci+S+c6eBRYqCRWlSaIwq
	 ewN17zsCZoacnmL9qAEAEVGGVfFng+qBiq3yS61ySiVR1jJ8m4UwgbkhGRrV/p/y/lo2O
	 8TSsJhpAF6xBtw6TWnsantoEI6JHGCJgJWiFZPxNGg25LJ4xE7oYSpZqKIgSzXalO2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793059070;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=7WMtPtdK1lzlrp4rQzyLZbJevL2RrG4eQh3LkZ7hUGo=;
	b=X35ppmRmWllOUa6ZhzzudJ3uFVeviADveDNQ24rEUX108S2oKkum0/28dpq4Nx+40FUt
	 kRlP8waoXocdC9PEL0wLEn/AR0wDawzQrP3pqkUVkV/D9afOcudSXfGsWgieavNop3sB0
	 pVKsSc096HA4K6QVQ0HLwTYVPTffhgxC7ag3Qy56d5DlvV6rsmm/qwFyH/qKN7XyuF3O1
	 iFVjHTym7soXMDb3FST9QptVScEbXGy3oHpBTCxfcmvE1rKyBB4qGj61YdO9zQT0IhvOj
	 cgNOus/cAYjwJrjPyyF38scnVTlQDEXXuzOixql6DvNV1q4jA4/qf40EFAEHmiZjXNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oLcqO6x0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC1A606A31A;
	Mon, 26 Oct 2026 23:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oLcqO6x0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319DF1F01825;
	Mon, 26 Oct 2026 23:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793059070;
	bh=7WMtPtdK1lzlrp4rQzyLZbJevL2RrG4eQh3LkZ7hUGo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oLcqO6x0oulfxlcnAKCrFhFbMWlL5/QD7QCywadLB6JldFjE5lm2gqVIo3EU5BbVg
	 WYbGn9mKBdKjVaFUnCUPMqmQXyqRsZwQop2IpmMILLdNuZamSlXfmPxYl42b21GzTY
	 9c8f7D782s7UBlXziEhUe3XlyW1YBlvEXrGm6xYB6GL+5gUeqWT7L1pqYWRG9v5w+E
	 +VifU758renDR/uattP2SNPTrFZJhcuUi/cb9IDF/QiOSCMe867XqHT0vgKsaUIMek
	 6lXfWErJGtfUayfFoTlL630dCbVmDt+MmVmDBEU6l7pz/vDDsqVL1levZTprqzETzI
	 2rE7a1V4u9WBw==
Date: Mon, 26 Oct 2026 16:57:47 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, Alex Shi <alexs@kernel.org>,
	Yanteng Si <si.yanteng@linux.dev>, Dongliang Mu <dzm91@hust.edu.cn>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Graf <tgraf@suug.ch>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Thomas Gleixner <tglx@kernel.org>, Waiman Long <longman@redhat.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:RHASHTABLE" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH v3 6/6] lib: Remove assoc_array
Message-ID: <20261026235747.GB2395@quark>
References: <20261025001105.1824178-1-jarkko@kernel.org>
 <20261025001105.1824178-7-jarkko@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261025001105.1824178-7-jarkko@kernel.org>

On Sun, Oct 25, 2026 at 03:10:14AM +0300, Jarkko Sakkinen wrote:
> As assoc_array has no longer in-kernel users, remove assoc_array
> implementation, includes and documentation.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>

Reviewed-by: Eric Biggers <ebiggers@kernel.org>

- Eric
