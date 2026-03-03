Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224EE3DBD66;
	Tue,  3 Mar 2026 16:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772556966; cv=none; b=MeMO5TgO92veiHFQQPBbE0siIC6AlwtwIpsN4mFrelzNkN4tWnV8J8flomAjKbLOLKfOexoWLfGt2eWb1Vmu/AE/Vm6oEahTytuuSS6qtAx3o7iUF290XsJpRtZRkj1CifYdNiZfm3r+1vRhgzWPYV9mLm24H5An9Pl78wVQEHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772556966; c=relaxed/simple;
	bh=PspKwEQyJf0sGxt3Osb+chOp3772zSkyGfm6ysAwHYc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U77YvgTF5vAoH13v0a3r80o29od89Xt25roGGJxBWunrNCSI/C9iAQ6BqeVwh6DJkvhheJUYzUE+vkomHviePUMG1TQX4Ex850xuufIwlzmo84LFfqIwG5PcmjsxT+Bovqw8GC7Ecew5jTLFfiHUVXTuTnHlg6ZZmYG+h2TR77k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sSjKUJrP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sSjKUJrP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F9AC116C6;
	Tue,  3 Mar 2026 16:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772556965;
	bh=PspKwEQyJf0sGxt3Osb+chOp3772zSkyGfm6ysAwHYc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sSjKUJrPBzRIJEib0UnUSBOhNY3IHP4dSv/oX2tq5IwYDRUdUJUKncey/ietImsoe
	 FYHNuueNEdsT41MevNnsmdEtTQChUYPyopSDBTZ6uaSQatRVQqxdtGErlaMgp0Etyx
	 2s8IZ622CpgP7f/3c4DU7B/zSWsc2F6E5WhvgJXUBiKlBpOvO+1O85JeA9nMYUV+X2
	 hYGJvaLL0dkxueTcYBKgqkvEfU+2nARYiFHpEOLempOhFzyqPlXtknH9Em5ONfVTxw
	 EWvvs5ZUUwvdZxFY9GJND/0DkHes+QguDxpnXsG2X7gQCi+Tg6xTe5BewuERRaCC94
	 IW816OBtPZwBg==
Date: Tue, 3 Mar 2026 22:25:50 +0530
From: Manivannan Sadhasivam <mani@kernel.org>
To: Bjorn Andersson <andersson@kernel.org>
Cc: Harshal Dev <harshal.dev@oss.qualcomm.com>, 
	Krzysztof Kozlowski <krzk@kernel.org>, Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Abel Vesa <abel.vesa@oss.qualcomm.com>, cros-qcom-dts-watchers@chromium.org, 
	Brian Masney <bmasney@redhat.com>, Neeraj Soni <neeraj.soni@oss.qualcomm.com>, 
	Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>, linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] dt-bindings: crypto: qcom,ice: Require
 power-domain and iface clk
Message-ID: <mns7565jbkjtmqioe5y3la4kpco43umbzpnxvfc73cnpxw7khy@7xcmoflqakuv>
References: <14a71b33-4c10-41b0-a6cb-585a38e05f56@kernel.org>
 <06160c6c-a945-467a-be82-7b33c5285d0f@oss.qualcomm.com>
 <7216c86d-2b87-496c-9548-ccdcb3c98b6b@oss.qualcomm.com>
 <1f99db18-d76c-4b87-9e30-423eee7037e1@oss.qualcomm.com>
 <dd34525c-0a25-47ae-9061-c4c7ab708306@kernel.org>
 <2830a189-a5ce-45a0-92fe-7a01c3b012a7@oss.qualcomm.com>
 <6efcdf51-bdb1-4dfc-aa5e-8b7dc8c68cd3@kernel.org>
 <b217a08a-2755-4ef8-bf39-af1c3e628cf8@oss.qualcomm.com>
 <3cxejy2jplgqufj5fivi27ii3rrcrhzdyvmxd4ekp2ik3aqa6l@tiwyslt3ng5p>
 <vpgeduh5fwgvbx42dujbm7x3vacbmwjgjkcmhpgcsaa2ig4cm3@kk34eaqoh6ww>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <vpgeduh5fwgvbx42dujbm7x3vacbmwjgjkcmhpgcsaa2ig4cm3@kk34eaqoh6ww>

On Fri, Feb 20, 2026 at 09:59:41AM -0600, Bjorn Andersson wrote:
> On Fri, Feb 20, 2026 at 08:01:59PM +0530, Manivannan Sadhasivam wrote:
> > On Mon, Feb 09, 2026 at 11:13:06AM +0530, Harshal Dev wrote:
> > > On 2/6/2026 4:20 PM, Krzysztof Kozlowski wrote:
> > > > On 06/02/2026 11:07, Harshal Dev wrote:
> > > >> On 2/5/2026 4:47 PM, Krzysztof Kozlowski wrote:
> > > >>> On 03/02/2026 10:26, Harshal Dev wrote:
> > > >>>> On 1/26/2026 3:59 PM, Konrad Dybcio wrote:
> > > >>>>> On 1/23/26 12:04 PM, Harshal Dev wrote:
> > > >>>>>> On 1/23/2026 2:27 PM, Krzysztof Kozlowski wrote:
> > > >>>>>>> On 23/01/2026 08:11, Harshal Dev wrote:
> [..]
> > > >>> My NAK for driver change stays. This is wrong approach - you cannot
> > > >>> break working DTS.
> > > >>>
> > > >>
> > > >> I agree that this patch in it's current form will break both the in-kernel and
> > > >> out of tree DTS written in accordance with the old binding. If this isn't acceptable
> > > > 
> > > > What? You just said few lines above:
> > > > "it will still continue to work if:"
> > > >
> > > 
> > > I hope I am clear now, 'it' referred to the in-tree ICE driver and not to this particular
> > > DT schema commit. :)
> > >  
> > > > So either this will continue to work or not. I don't understand this
> > > > thread and honestly do not have patience for it. I gave you already
> > > > reasoning what is wrong and why it is. Now it is just wasting my time.
> > > > 
> > > 
> > > Apologies again for the confusion. I totally agree, as replied previously too, that the
> > > updated DT binding breaks backward compatibility. Like I said, I will post another patch
> > > to preserve the correctness of existing in-tree and out-of-tree DTS.
> > > 
> > 
> > The ICE hardware cannot work without 'iface' clock and the power domain, which
> > are shared with the UFS PHY. One can argue that ICE is actually a part of the
> > peripherals like UFS/eMMC, but I don't have access to internal layout, so cannot
> > comment on that. I ran into this issue today when I tried to rmmod ice driver
> > together with ufs_qcom driver and got SError when reloading the module because
> > ice driver was trying to access unclocked/unpowered register.
> > 
> > But you should mark the resources as 'required' in the binding and justify the
> > ABI break. No need to preserve backwards compatibility here as the binding was
> > wrong from day one.
> > 
> 
> Marking it "required" in the binding, implies that it's fine for the
> driver to fail in its absence. If I understand correctly that will
> prevent UFS and eMMC from probing, unless you have a DTB from "the
> future".
> 
> Even if I merge the dt-binding change through the qcom-tree (together
> with the driver change) I will not guarantee that torvalds/master will
> remain bisectable - because dts changes and driver changes goes in
> different branches.
> 

Yeah, that's true.

> 
> As such, the pragmatic approach is to introduce the clock as optional
> and then once we're "certain" that the dts changes has propagated we
> can consider breaking the backwards compatibility.
> 

Only if we remember to mark it required some point, fine with me!

- Mani

-- 
மணிவண்ணன் சதாசிவம்
