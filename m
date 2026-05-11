Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77089370D4D;
	Mon, 11 May 2026 14:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778509553; cv=none; b=K0V/U0NOHiBap0QEEekLLMPirgz3CaplemB6cVaQ6/+SV4iNK0xCHIhBJKfsreW0g5UJVrnOxLAr+2/SX3KjK+XeTGnzx8qTfU35QpGlS1ws+KrrIZvRey1cw4JDGc9uDYHrhdfIPpqcXg53Aasopue3Bbd5VK1NxZmCpIg/rDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778509553; c=relaxed/simple;
	bh=mexmImOY5fBW1qxWFhDOoLaRXOky5Sdge7hTZ/K6IIU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BSFsVt4fHPJDdO3MWQNnh72WxtrFsC83LxwTdRoNHiLirBPNhtBHq5YasRAD9yR0oqUB3OxMAk0h4MueHnxqG2EjnqmXDuKO/INPNZDrVKz4OI4lJLMDlxLOkkehk+5jOI6bEdBSUCXFewAByEvY9e7irKngWZncgJTJQgVI3HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dWG5BRtQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dWG5BRtQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30E2C2BCC9;
	Mon, 11 May 2026 14:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778509553;
	bh=mexmImOY5fBW1qxWFhDOoLaRXOky5Sdge7hTZ/K6IIU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dWG5BRtQPrksKZtjKHD4FHH+i/KiRKgXSio8Eegb0cMqpMrM2vEDXylujvtqk+bg0
	 KTCQxRFVmOImlY8EgjIy9c6+8HqyGWPhifsXjo2zxK5IeFqOTuUr4XuI/RNMqIjQKa
	 nL05N3MaJV/VwD3L/z9AdZJB7x4f68ABTYlGmw3W02pOOCtF2A19OvPCIhBLoECph+
	 2yUpdyu4EPWxanzv5IJEdJYk3nmtyiYH+VBbpiGvYS7F2WjRRrdJHLH59Wz6v/98c0
	 Ec0tMTrUO0zT5KNpTbA/5ZM+c72+5+60F5ffcFM9hOLlNkYqMgr24zflIWfIznaec1
	 ji4TAN74Op8Gg==
Date: Mon, 11 May 2026 08:25:50 -0600
From: Tycho Andersen <tycho@kernel.org>
To: "Pratik R. Sampat" <prsampat@amd.com>
Cc: ashish.kalra@amd.com, thomas.lendacky@amd.com, john.allen@amd.com, 
	herbert@gondor.apana.org.au, davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, aik@amd.com, nikunj@amd.com, michael.roth@amd.com
Subject: Re: [RFC v2] crypto/ccp: Introduce SNP_VERIFY_MITIGATION command
Message-ID: <agHl3ow90IdKTS72@tycho.pizza>
References: <20260501152051.17469-1-prsampat@amd.com>
 <afitM-Ub50JsTCHz@tycho.pizza>
 <673592c4-8eca-4b84-9f60-7020327d1afd@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <673592c4-8eca-4b84-9f60-7020327d1afd@amd.com>

On Fri, May 08, 2026 at 05:10:52PM -0400, Pratik R. Sampat wrote:
> Hi Tycho,
> 
> Missed this one in my mailbox. Thanks for the review!
> 
> On 5/4/26 10:32 AM, Tycho Andersen wrote:
> > On Fri, May 01, 2026 at 11:20:51AM -0400, Pratik R. Sampat wrote:
> >>   - failed_status (read-only): firmware-reported failure status from the
> >>     last operation, as returned alongside the status vectors
> > 
> > "from the last operation" is not quite right here, it looks like it
> > re-runs the STATUS command and reports that error?
> 
> That is correct. It runs the STATUS command and reports the status of the
> verification operation. Probably better to phrase it as the "last verification
> operation" instead?

Hmm, I'm not sure what you mean here. The FW spec 1.58 table 132 says:

    Command to request the firmware to return information regarding the
    currently supported (available) mitigations, and then the verified
    (processed and completed) mitigations. If DST_PADDR_EN is set,
    DST_PADDR will be populated with the SNP_VERIFY_MITIGATION_DST_PADDR
    structure.

so I don't think it has anything to do with the last VERIFY operation?

The spec is a bit messy here, though. Table 131 mentions a
MIT_REQ_CHECK operation, which I assume should really be _STATUS. It
describes what the output VECTOR should be for VERIFY in table 131,
but not what it is for STATUS. Table 132 suggests the output VECTOR is
the list of supported mitigations, which matches what I was seeing
when I played with this.

Tycho
