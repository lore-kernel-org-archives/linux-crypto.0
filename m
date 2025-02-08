Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A53724112E;
	Sat,  8 Feb 2025 18:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739041185; cv=none; b=dBSx09sEeYyzMqwQEx0GtN86oL5tWCbiGJNV+87nlDr+3LXHJD5kyqU51QjgLDkGAgyjMyV+DOEvJeno6ur9RVWjP3b7pdwTP/k7HBjIqlSqlsiOR2MeuK6gBZ8CHKN8RXoYMZ2Ynwzrj3f4ccC6AssRWvjabMAVN/Sk6PrM01Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739041185; c=relaxed/simple;
	bh=ozsiJZSNpF0ElnyAxTg8ZjenCa9QxgqWXz85PH9Yn0E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EmEC2eVG0E5p/ikE0IaMDvtIyhnaPwaNRv1aEuTRyR9oL+7jDUcnbP9ItL6qH4S6P4QIcsyZzVcqQFh0R+NOLcqhx01cM5OguMDKwYUHF+XrhpBj/QipesH4FjXmnL93n9Vr30pN/lMcRjzuhMOHJ7k6xaZzqB/oP1Msmb3gEnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RYhLZ+aM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RYhLZ+aM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91125C4CED6;
	Sat,  8 Feb 2025 18:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739041183;
	bh=ozsiJZSNpF0ElnyAxTg8ZjenCa9QxgqWXz85PH9Yn0E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RYhLZ+aM6hZrl9EXCVbCaCpvq2iO7jqNpzz56rB5MF7RDvl996f92ZgOrNRvDCL9H
	 XG+h1Mh4JaXm8i/p40pv7CV1BliIjZXbUfLHb8Dqr3U7X2Tj2xVJvmCOqGDKMem5Fs
	 YcK07LA0BSOng3lSMxnq9i9DB4n59PL7evRDrQVgwLFJosBaYT884ygGDWBVQs4mU3
	 iGSxbEfVJLUUwcDm7i3IZmWoBPW1PxHeVzslsHqaXZ2UAbPfOX4D7NA0Lug7of1190
	 z1GiN0HjnrwgvqXMbmgknR7SietGuCDtRPURM2s3xZ+YyqqEhbFpIJrJgGi9aRrIN0
	 u/nbQMCSbjxTQ==
Date: Sat, 8 Feb 2025 10:59:35 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, x86@kernel.org,
	linux-block@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 03/11] lib/crc64: rename CRC64-Rocksoft to CRC64-NVME
Message-ID: <20250208185935.GA1087@quark.localdomain>
References: <20250130035130.180676-1-ebiggers@kernel.org>
 <20250130035130.180676-4-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250130035130.180676-4-ebiggers@kernel.org>

On Wed, Jan 29, 2025 at 07:51:22PM -0800, Eric Biggers wrote:
> The NVME NVM Command Set Specification has a table that gives the
> "Rocksoft Model Parameters" for the CRC variant it uses.  When support
> for this CRC variant was added to Linux, this table seems to have been
> misinterpreted as naming the CRC variant the "Rocksoft" CRC.  In fact,
> the CRC variant is not explicitly named by the NVME spec.

Making a small correction to this commit message: the spec actually does name
this CRC variant, as "NVM Express 64b CRC".  (The name is one of the listed
Rocksoft Model Parameters.)  So that further supports using nvme in the name.

- Eric
