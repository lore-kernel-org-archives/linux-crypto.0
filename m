Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 834573624A8;
	Tue, 28 Jul 2026 03:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785210071; cv=none; b=cE1aw8H69YNApMJtJZuZQ/xp/YLz/sPt2FJuyeFr3Hv2QczsDd1cOVSk07iWizjoAFB6tUI2/1FC+94ExrMM35yHLNBovgyz8j9UHOeeKsxyHAy7dc6SQ7ea6K0dloQc81HUTPRKA4DtJgvaxpC3snhiob4vQAachKaEMtG83c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785210071; c=relaxed/simple;
	bh=cA78QBzHmkLvAUUdVIUp/VZli9DJsAoJPO8K/XCSt+o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CE5fX9UXlH7F5H14sdflK0DZxqebFxtaT+JnGLx7JJd/1DWwTubx+OTI5xEVAClG/hnvTFIxzwX7CPm87oPlrM5f0wSj61bLrJosm+SDm0teD6HOHcS+rU9pibCSax4WzxI/dEEBwIhof02JFy4rKPLlXdDaFbwtsiupimJpu6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8775768AFE; Tue, 28 Jul 2026 05:41:05 +0200 (CEST)
Date: Tue, 28 Jul 2026 05:41:05 +0200
From: Christoph Hellwig <hch@lst.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: x86@kernel.org, linux-um@lists.infradead.org,
	linux-raid@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 7/8] lib/raid/xor: x86: Remove redundant
 X86_FEATURE_OSXSAVE check
Message-ID: <20260728034105.GC18902@lst.de>
References: <20260728021603.79870-1-ebiggers@kernel.org> <20260728021603.79870-8-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728021603.79870-8-ebiggers@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

The prefix here should be just xor: to stick with the existing commits.

