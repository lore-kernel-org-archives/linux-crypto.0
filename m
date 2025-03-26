Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B161E4AE;
	Wed, 26 Mar 2025 16:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743008349; cv=none; b=jjynvkdQWvcfnIQFkTzzj6IkOoTcGNWDwhFju75mxmM6lK+mwZigx/n3N7leh2eLqWiE9BsJtgByX0StGgD5GfBPIPaeaSkBhkQ68tPN0zcOK4/JHcw6vvLi42xCxOL/rIEa5rdz9OUeSZsMK7jzxiU1WC9LVeXQqBCjtt2CoFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743008349; c=relaxed/simple;
	bh=ipn5myIp1HsxBnoqD80mU7TAbi2ASqH1gBOodIKEWj8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JDwtN9RT2SDWVQRLaKmX7lRZUq6sYdyN2OzCvb7q2KKJ0dkP+sYxFOT5xw2Rhvjl8Bq0wgPc3+7mX21G9WW7yB4SI+mMNjRPbyGyJFdZTcnayE2XYNktXtt8I0gTbRxsu7TMGqMaQaBrR9xBbi8axyRp8bMsu4P1xqhu4WysGmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yv/kwjYt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yv/kwjYt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9417C4CEE8;
	Wed, 26 Mar 2025 16:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743008349;
	bh=ipn5myIp1HsxBnoqD80mU7TAbi2ASqH1gBOodIKEWj8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Yv/kwjYtPcCAkP6dI1VjlEdSg0blG+iFdk9Gw13ywPlVPR4vYHGXF9wngEyCZiQxq
	 CmHacaDyBb+mDNgm5CBHWH7TKACS/e+1sicqNQEGKxRriVbvoqKFpYr9J9G9f3Ug6X
	 Fkp2LCNLH1iPqPEu4qDBlwXKSvHBuPkpEtimtzdHjDHQsf4zKE957b76JciUBBCdpJ
	 +ipcsBHJylEAMClSo2pcLyYZQNhC44WWJxPfLKJBITk+QvLbUOVwaYm/mKU/SYmZyM
	 pD6VrdXIq9JoDcKN0hgl2lRevG4EI/xhCeQOfzILxFIMNUXPc+EWMK3QKUw3mzIIA2
	 J7on3GjMPOOfg==
Date: Wed, 26 Mar 2025 09:59:07 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Bartosz Golaszewski <brgl@bgdev.pl>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Kees Cook <kees@kernel.org>,
	Jens Wiklander <jens.wiklander@linaro.org>,
	Joakim Bech <joakim.bech@linaro.org>,
	"open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Daniel Perez-Zoghbi <dperezzo@quicinc.com>,
	Gaurav Kashyap <gaurkash@qti.qualcomm.com>,
	Udit Tiwari <utiwari@qti.qualcomm.com>,
	Md Sadre Alam <mdalam@qti.qualcomm.com>,
	Amirreza Zarrabi <quic_azarrabi@quicinc.com>
Subject: Re: Extending the kernel crypto uAPI to support decryption into
 secure buffers
Message-ID: <20250326165907.GC1243@sol.localdomain>
References: <CAMRc=MdO=vPrvvonJPJ=1Lp0vFTRBtsEBUS5aqWp4yMqUtgfzw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMRc=MdO=vPrvvonJPJ=1Lp0vFTRBtsEBUS5aqWp4yMqUtgfzw@mail.gmail.com>

On Tue, Mar 25, 2025 at 09:23:09PM +0100, Bartosz Golaszewski wrote:
> Hi Herbert et al!
> 
> There are many out-of-tree implementations of DRM stacks (Widevine or
> otherwise) by several vendors out there but so far there's none using
> mainline kernel exclusively.
> 
> Now that Jens' work[1] on restricted DMA buffers is pretty far along
> as is the QTEE implementation from Amirreza, most pieces seem to be
> close to falling into place and I'd like to tackl
> e the task of implementing Widevine for Qualcomm platforms on linux.
> 
> I know that talk is cheap but before I show any actual code, I'd like
> to first discuss the potential extensions to the kernel crypto uAPI
> that this work would require.
> 
> First: why would we need any changes to the crypto uAPI at all? After
> all other existing implementations typically go around it and talk
> directly to the TrustZone. That's right but IMO t
> here's some benefit of factoring out the common low-level elements
> behind a well-known abstraction layer. Especially since TA
> implementations may differ. Also: in the case of the Qualcom
> m trusted OS, the single-threaded implementation makes it preferable
> to offload only a limited set of operations to the TA to not keep it
> overly busy so a dedicated kernel driver can han
> dle most of the crypto engine's functionality on the linux side.
> 
> And in general being able to decrypt into secure buffers may benefit
> other use-cases too.
> 
> There are at least two points that need addressing in the crypto uAPI.
> 
> 1. Support for secure keys.
> 
> This can be approached in two ways:
> 
> - We may expect users to already have generated the secure keys from
> user-space directly over the TEE interface, retrieve some kind of a
> handle (secure key index, wrapped key, TBD) and p
> ass it down to the crypto framework via setsockopt().
> 
> We'd probably need to add a new optname: ALG_SET_SECURE_KEY or
> ALG_SELECT_SECURE_KEY or even ALG_SELECT_KEY in order to differentiate
> from the raw keys passed alongside ALG_SET_KEY.
> 
> The underlying crypto driver would then have to be able to select the
> key from the TZ. In this scenario the crypto core assumes the keys are
> already programmed in the secure enclave and
> it's just a matter of selecting the right one.
> 
> - We may also prefer to do everything via the crypto uAPI, including
> generating secure keys. This has the benefit of adding a nice
> abstraction layer for various trusted OS implementation
> s which differ from one vendor to another.
> 
> To that end we'd need to introduce a new af_alg_type instance that
> would allow us to manage secure keys via setsockopt() or
> read()/write() in addition to the above.
> 
> An example user-space side would look like this:
> 
> struct sockaddr_alg sa = {
>    .salg_family = AF_ALG,
>    .salg_type = "securekey",
>    .salg_name = "qtee", /* Qualcomm TEE implementation */
> };
> 
> sock = socket(...);
> bind(...);
> fd = accept(sock, ...);
> header->cmsg_level = SOL_ALG;
> header->cmsg_type = ALG_GENERATE_KEY;
> sendmsg()
> 
> 2. Decrypting data into secure buffers.
> 
> Here we'd need two things:
> 
> - passing file descriptors associated with secure buffers to the crypto API
> 
> Other than using setsockopt() to select the secure key, selecting a
> symmetric cypher wouldn't differ from raw implementations but the
> message we're sending over sendmsg() would need to c
> ontain another entry that would contain the file descriptor associated
> with the secure buffer. To that end I imagine adding a new socket
> option code: ALG_SET_MEM_FD.
> 
> - one-way decryption into the secure buffer
> 
> This would mean that the write() of encrypted data into the socket
> would not be paired with a corresponding read() of the decrypted data
> back into user-space. Instead, we'd need a mechan
> ism of getting notified that the decryption completed (successfully or
> with an error). That could be achieved by polling the socket for
> POLLIN | POLLERR. A read() on such a descriptor wo
> uld return -EOPNOTSUPP.
> 
> Please let me know your thoughts on this and whether any of the above
> even makes sense. If it's not a terrible approach, I will start
> working on a functional PoC. Please note, that I'm n
> ot very well versed in linux crypto so I may very well be talking
> nonsense. In that case any advice is welcome.
> 
> Thanks,
> Bartosz
> 
> [1] https://lore.kernel.org/all/20250305130634.1850178-1-jens.wiklander@linaro.org/
> [2] https://lore.kernel.org/lkml/20250202-qcom-tee-using-tee-ss-without-mem-obj-v2-0-297eacd0d34f@quicinc.com/

What would you get out of building this on top of AF_ALG, vs. building a new
UAPI from scratch?  There seem to be an awful lot of differences between what
this needs and what AF_ALG does.

- Eric
