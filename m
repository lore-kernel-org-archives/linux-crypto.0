Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2652F25F0
	for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 15:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774883812; cv=none; b=K3xvEG+zBE3FJOj+RQVW/5p9+b8hgoxsu2jeHAhlwyWlGF2atk+aV+OukV1JBP4WMWH8eK4x+N9GBGqE/5bdcRrHHViKJTIMOK9lBsLpJeNfLEXfSiQ/drjF0E2b16hj7Y9l1RaIceWeepSQJ+bXLZkqUaRu5zbsJLHopvxExmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774883812; c=relaxed/simple;
	bh=NaVH8zIkqEU9AmQE+qLztKesEUMzinfCvffvpnQjuyQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n4XZjOglAHEMn0pPwR2gE7lqgUtr9SSri4gPmh4J0wKR1fpF/RQrVIxtoE2E18t3c6k8EYFLDmN88pUlWino2THWL/6jq9vovYpo6pPcrezWvmkj3A/vSYtIim3C118084R0ADTOUYLHpaNUkeIPABXAmIOYfVECwi04DR3g/7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SJZXbHr7; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=pnucoW9B; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SJZXbHr7";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="pnucoW9B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774883809;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=beybqvcHZSF5ZRRU/l09CbOmW2h45yqjTC07lws0qAA=;
	b=SJZXbHr7nQOBX5oozngNRdGHnxJA6vXpiPG8edLaFRNQIzNwIQjjvRRUJKWYCovMknceJw
	UvcX5dZik57GQ33eYN3IlTUfqq6TbaMIkFqh/9/NL7YZ4LvfplVmqMdgWcCuXZ6d37LaAQ
	DPkZ7qDmDO5tuSbsXECu2MWoLlSELJM=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-612-aIs9ima4O3Cr0MgWVy4a9A-1; Mon, 30 Mar 2026 11:16:48 -0400
X-MC-Unique: aIs9ima4O3Cr0MgWVy4a9A-1
X-Mimecast-MFC-AGG-ID: aIs9ima4O3Cr0MgWVy4a9A_1774883808
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8cd77e5e187so778220585a.1
        for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 08:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1774883808; x=1775488608; darn=vger.kernel.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=beybqvcHZSF5ZRRU/l09CbOmW2h45yqjTC07lws0qAA=;
        b=pnucoW9BDxiiYnarMq7wcIbhr40vyrhzuWZgDJJqSDvattYjknVyHet34Ae9Mv1tQ+
         kt6ZKLtGGENenyXoG4nvp7OfFaBv6OMlVGNcDbbkQXHo4L3LbghH8TCoyBhuHTFeHQlg
         ehjImeap2Z2jclbM1K5PCh0Ds/57M4hP358VHsi6laAF6TqEpSIP/0ApBlAJ8T4MZmXn
         O87NHKzFbjGolQ7y5FcFYQ/b9ftn/Mjr/ikrvusV2MV3FYt3Cnm7TabFqhUO+esII+a2
         ukkhPrvfln8e3a6gHaNUl1sprq0ZyFGiaAi5a0Dj6saxohz66cPfib3cQ8xkcnq0mo1m
         ytvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774883808; x=1775488608;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=beybqvcHZSF5ZRRU/l09CbOmW2h45yqjTC07lws0qAA=;
        b=ghRG3f+gzhcf3Eh7yCZpQtQeRWgg416W7e/qTpmQGkFOaq7X4DzX1DJg1Hsk2sY+WZ
         S0gWy0iDFKKd4Up7mjdJ1f6PvamOEJ/bdhqNa7NyqN/fgHP41i67KY4VYu7fd7BQdM9P
         3dw5Ahy09TEFkBNesGgWkMGazhDxY3lsD3BVlYoXwWcXAHdZc/bUAN+yKCg/FKOaB9Ce
         nZstpb+Up5ResRoXRi3ivXYa427PMA9o3sT8Y+jSWR86fLhrKKHixqKhjq1DLfoIdSMH
         LAAKkaMdgvoQ9B/fUlN6upTisZKJoV6QpRyVyGQ7uPGJlAw4Pfd4e+z5vyaW3ARFLzGq
         bKuQ==
X-Forwarded-Encrypted: i=1; AJvYcCWOAlfYMPuDxUFfBIe9S31W/GZnn/W7b4whEYPR4s4vVMmtWq82/tlpHzGcKcy7ObAjNDBEt5G0vzTvEYE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5LMiLOuuf/TF4rBxqB7wKizydPP1znKtiYZrlegdkWs+ae5Lk
	J6Z/pzcWaU5lqAUXtnfpp05mk3pcpv1mKEFh+U8Mgh9ESKhACR7J29WX1vhYiKQheH6m6xKwd9R
	e1xgpwDW8AIyvZLz0O/PQ/o4j1L2vCL2Sdt/wuoBaXBTKihWdTymcPWq8JFL3ZDONwg==
X-Gm-Gg: ATEYQzzNyMHOYSVyWw7S4g9TApnX5akSR2pK5UtZtvE24uw9XsWzQBeUfLckKq65sP+
	b87CpthDbZ03jLX37MBH/b3OjGW8JbsQAv2/vuF/cEx0xZjY5LiWdWNYOkU+wIB+fWK4aUIfOq4
	lOAzjKFHZTCSHqMixk07IiCWYVYVHPYtv+YNa9yjaw7jgQtw8kyzUvdK71iyFTxPB4FxzaEDeXi
	jJ4fKWP7p8NzEK5xBv+EuPLIwfXbx075E/r1VZv1GPqx90l5z93MOU3yQsfWcHe+6fcVXZLUpRM
	6ZYb8up4174h1TE4x8Zo4gRmI3Zb1OUzSWShPKTdU5xj6PWoAJl2EV1/Yf505Q3ARkwq20x+MR+
	2FY5IFHWC6Xxmjl41za3yoPhbzF2G4aCqycpm/MI5kiWYa3D6y/0uVid2
X-Received: by 2002:a05:620a:448a:b0:8cd:c04f:c6a1 with SMTP id af79cd13be357-8d01c816db2mr1669490685a.58.1774883807923;
        Mon, 30 Mar 2026 08:16:47 -0700 (PDT)
X-Received: by 2002:a05:620a:448a:b0:8cd:c04f:c6a1 with SMTP id af79cd13be357-8d01c816db2mr1669485885a.58.1774883807244;
        Mon, 30 Mar 2026 08:16:47 -0700 (PDT)
Received: from redhat.com (c-73-183-52-120.hsd1.pa.comcast.net. [73.183.52.120])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8d02806a37bsm617484985a.34.2026.03.30.08.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 08:16:46 -0700 (PDT)
Date: Mon, 30 Mar 2026 11:16:44 -0400
From: Brian Masney <bmasney@redhat.com>
To: "Miquel Raynal (Schneider Electric)" <miquel.raynal@bootlin.com>
Cc: Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jayesh Choudhary <j-choudhary@ti.com>,
	"David S. Miller" <davem@davemloft.net>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Antoine Tenart <atenart@kernel.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Magnus Damm <magnus.damm@gmail.com>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	Pascal EBERHARD <pascal.eberhard@se.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	linux-clk@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org,
	Herve Codina <herve.codina@bootlin.com>
Subject: Re: [PATCH 10/16] clk: Add support for clock nexus dt bindings
Message-ID: <acqT3Dh03y3JiLLc@redhat.com>
References: <20260327-schneider-v7-0-rc1-crypto-v1-0-5e6ff7853994@bootlin.com>
 <20260327-schneider-v7-0-rc1-crypto-v1-10-5e6ff7853994@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327-schneider-v7-0-rc1-crypto-v1-10-5e6ff7853994@bootlin.com>
User-Agent: Mutt/2.3.0 (2026-01-25)

On Fri, Mar 27, 2026 at 09:09:32PM +0100, Miquel Raynal (Schneider Electric) wrote:
> A nexus node is some kind of parent device abstracting the outer
> connections. They are particularly useful for describing connectors-like
> interfaces but not only. Certain IP blocks will typically include inner
> blocks and distribute resources to them.
> 
> In the case of clocks, there is already the concept of clock controller,
> but this usually indicates some kind of control over the said clock,
> ie. gate or rate control. When there is none of this, an existing
> approach is to reference the upper clock, which is wrong from a hardware
> point of view.
> 
> Nexus nodes are already part of the device-tree specification and clocks
> are already mentioned:
> https://github.com/devicetree-org/devicetree-specification/blob/v0.4/source/chapter2-devicetree-basics.rst#nexus-nodes-and-specifier-mapping
> 
> Following the introductions of nexus nodes support for interrupts, gpios
> and pwms, here is the same logic applied again to the clk subsystem,
> just by transitioning from of_parse_phandle_with_args() to
> of_parse_phandle_with_args_map():
> 
> * Nexus OF support:
> commit bd6f2fd5a1d5 ("of: Support parsing phandle argument lists through a nexus node")
> * GPIO adoption:
> commit c11e6f0f04db ("gpio: Support gpio nexus dt bindings")
> * PWM adoption:
> commit e71e46a6f19c ("pwm: Add support for pwm nexus dt bindings")
> 
> Expected Nexus properties supported:
> - clock-map: maps inner clocks to inlet clocks,
> - clock-map-mask: specifier cell(s) which will be remapped,
> - clock-map-pass-thru: specifier cell(s) not used for remapping,
>   forwarded as-is.
> 
> In my own usage I had to deal with controllers where clock-map-mask and
> clock-map-pass-thru were not relevant, but here is a made up example
> showing how all these properties could go together:
> 
> Example:
>     soc_clk: clock-controller {
>         #clock-cells = <2>;
>     };
> 
>     container: container {
>         #clock-cells = <2>;
>         clock-map = <0 0 &soc_clk 2 0>,
>                     <1 0 &soc_clk 6 0>;
>         clock-map-mask = <0xffffffff 0x0>;
>         clock-map-pass-thru = <0x0 0xffffffff>;
> 
>         child-device {
>             clocks = <&container 1 0>;
> 	    /* This is equivalent to <&soc_clk 6 0> */
>         };
>     };
> 
> The child device does not need to know about the outer implementation,
> and only knows about what the nexus provides. The nexus acts as a
> pass-through, with no extra control.
> 
> Signed-off-by: Miquel Raynal (Schneider Electric) <miquel.raynal@bootlin.com>
> Reviewed-by: Herve Codina <herve.codina@bootlin.com>
> ---
>  drivers/clk/clk.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 93e33ff30f3a..196ba727e84b 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -5218,8 +5218,8 @@ static int of_parse_clkspec(const struct device_node *np, int index,
>  		 */
>  		if (name)
>  			index = of_property_match_string(np, "clock-names", name);
> -		ret = of_parse_phandle_with_args(np, "clocks", "#clock-cells",
> -						 index, out_args);
> +		ret = of_parse_phandle_with_args_map(np, "clocks", "clock",
> +						     index, out_args);

Before I left my Reviewed-by, I should have double checked Sashiko. It
has several questions about this patch. The first is:

    Are there other places in the clock framework that need to transition to the
    new map API to ensure assigned clocks work?
    
    For instance, assigned-clocks and assigned-clock-parents are parsed in
    drivers/clk/clk-conf.c using of_parse_phandle_with_args(). If a device
    specifies an assigned clock that routes through a nexus node, will it fail
    to configure because the map is not traversed?

https://sashiko.dev/#/patchset/20260327-schneider-v7-0-rc1-crypto-v1-0-5e6ff7853994%40bootlin.com?patch=12563

Brian

