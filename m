Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C1041E9B28;
	Thu, 30 Jan 2025 15:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738249790; cv=none; b=TUe2bjnDDkrGMaT0nt1k5R7dAA0DW3O1AkTBnvYQG5SM2XOpy+cS5f9BkT7XnVuQgu5fZ3anJxwPKnu9MZlCI8uE7WOupvhy42vZw1MI6k5oVGbN4cBqx/ErbGNxFRdf0CFKY0qsteQByKkbZCIibin+d09c5VJZPOqjv7gVRpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738249790; c=relaxed/simple;
	bh=BmvrqUeskOzmL87ygitO7gL+DDkfBFwSTEs/5Pv1ceI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O7BCAFU1uYjbohagFJTTpKYfUSwHGmYGFutgX8URkenuxStuWCy3tHou6G9znk0rqRqLs0kHbb5UeD4S1sz+KoUw4BUmNhzEIY0rH6KCke6gn/hnvvvxwpUhPyX8MnHrGAx+LhIYR22q/+8FhnYt2QZ6i9Qd/Og5XYVXgz4PC60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e8WP4n5i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e8WP4n5i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD762C4CED2;
	Thu, 30 Jan 2025 15:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738249789;
	bh=BmvrqUeskOzmL87ygitO7gL+DDkfBFwSTEs/5Pv1ceI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=e8WP4n5iI+VUnz5D4D7bq7gCNn9cqx6ps9bG28REVuNCs2UlEC/zF54qeIgqCqgZ8
	 Jz8M8KF0+fByiqPY5QLl41xxHnfyDvfOg1+TaxOPuiHoNxngq4Qho/0KsVk6MqOvBk
	 xxCoXcIkYNK7mgPziaJN4xBFic7FXuPO/fsdwzZ+rJfd8SLE4OlPuPro3SlHEAz3SD
	 +LbHANctn8I+QMBB+FkGhmUusrN0rcdkbHZT6iIswNiG0vMpypxuWxF6chsmGJ5HIk
	 f6ra5W43FWBrc6oTku5YeUu5/PV1l6HQ+GWLcF1Eb/jV+RCPYePNwvyBd3X2BZgjYy
	 TC2No3Kef5Wtg==
Date: Thu, 30 Jan 2025 08:09:46 -0700
From: Keith Busch <kbusch@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	x86@kernel.org, linux-block@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 00/11] CRC64 library rework and x86 CRC optimization
Message-ID: <Z5uWOnj8T7OO4LH8@kbusch-mbp>
References: <20250130035130.180676-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250130035130.180676-1-ebiggers@kernel.org>

On Wed, Jan 29, 2025 at 07:51:19PM -0800, Eric Biggers wrote:
> Patch 11 wires up the same optimization to crc64_be() and crc64_nvme()
> (a.k.a. the old "crc64_rocksoft") which previously were unoptimized,

Yes, I mistakenly thought the name of the table in the spec was the
name of the CRC, but that was just referring to format of how the
parameters were displayed. It really should have been crc64_nvme, so
thank you for clearing up the naming confusion.

> improving the performance of those CRC functions by as much as 100x.

Awesome!

Looks good:

Acked-by: Keith Busch <kbusch@kernel.org>
