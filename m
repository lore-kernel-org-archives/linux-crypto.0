Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0DE637104D;
	Mon, 23 Feb 2026 22:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771884888; cv=none; b=kqGASqSfS4m9KqLf60FPiVFQnJ/Nxn4mAwjvSWC6Luihg//1kWMeo31pyvO3GREZBcH4pNb+mGfCcutp6hqVzFyh1mxKLe5Kbe2nF65DhiS63ZORp4SQSEbcFSfZob//Q4Dt7g8uiEFvebFfW7sDIjgXlQghEmQTQMTMjkWHAjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771884888; c=relaxed/simple;
	bh=4kH174067DzI+LXZAng55RHiqKZbdN+aHW/t4m7nco4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ebrFjN/eS54NYuuBmAJCiupBCgel12pPGFYefXesWMHy5UMiQCG+3vEIytQq2LTj+cK8YSIHOojefLJYoYCbUsvQhdffdvqAXqRnPpyQ6tAWNwcVOBWI86zaMp0YmZ+EXbITIBENwZZq2ccDJjr8CVHXL47b4581Xy66qMQPibI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZC11twMr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZC11twMr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 251D5C116C6;
	Mon, 23 Feb 2026 22:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771884888;
	bh=4kH174067DzI+LXZAng55RHiqKZbdN+aHW/t4m7nco4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZC11twMrmgGTJXn8dEA/A2mDLi28NFLZbvffIeU4a+aHmvvJrlJ/6MAFilWfXwMoJ
	 BSemHdih76UPmdkWqnldt6n3Fwi1hwuMhL2sjp+t0+quDj3jEO3tDCW4YLwT284Foi
	 S6z4FL83KYE7iMUf/E4VETzJoTwEYnnWMCCn1oHhDcBY0jTeijJhWSkeZP27+EhzN7
	 K9y8QzzUKZ7y2Yy7JG+cNXOJvyfKLAJBpbENYdmP7tGcobH1oj8SZTilY1nTraqXzV
	 97jfPATwFt7BAhQVY6nKPTJgbx2CemPoFMEn1Wb4HUbmbH589x14g+2VPz4jpZeSXR
	 hU+AR/nmueeDw==
Date: Mon, 23 Feb 2026 15:14:45 -0700
From: Tycho Andersen <tycho@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 3/4] crypto/ccp: support setting RAPL_DIS in SNP_INIT_EX
Message-ID: <aZzRVXp_E3cMcgtX@tycho.pizza>
References: <20260223162900.772669-1-tycho@kernel.org>
 <20260223162900.772669-4-tycho@kernel.org>
 <aZyC89v9JAVEPeLt@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZyC89v9JAVEPeLt@google.com>

On Mon, Feb 23, 2026 at 08:40:19AM -0800, Sean Christopherson wrote:
> On Mon, Feb 23, 2026, Tycho Andersen wrote:
> > From: "Tycho Andersen (AMD)" <tycho@kernel.org>
> > 
> > The kernel allows setting the RAPL_DIS policy bit, but had no way to set
> 
> Please actually say what RAPL_DIS is and does, and explain why this is the
> correct approach.  I genuinely have no idea what the impact of this patch is,
> (beyond disabling something, obviously).

Sure, the easiest thing is probably to quote the firmware PDF:

    Some processors support the Running Average Power Limit (RAPL)
    feature which provides information about power utilization of
    software. RAPL can be disabled using the RAPL_DIS flag in
    SNP_INIT_EX to disable RAPL while SNP firmware is in the INIT
    state. Guests may require that RAPL is disabled by using the
    POLICY.RAPL_DIS guest policy flag.

I'll add this to the message in the next version.

I will also split out the RAPL_DIS stuff from the test fix for the
firmware update.

Tycho
