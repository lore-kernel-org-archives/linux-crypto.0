Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB3F32252D;
	Wed, 21 Jan 2026 02:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768962008; cv=none; b=kHs5gWCGbMYtHvKSK5Ia0Nc+70Z7AqunciInYgRzE1087PBFiAPrdZPFz3M1ddLnxRJclyzgHaBpA+3CNc3A7M7FWIN08rKXJ/Xvc0RMd3WvyrF/8RqfgM+5oP0WPOmQIwdNSI0KraeJ+Hl+xo58z9RkiL83QVUuONh8TctQG4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768962008; c=relaxed/simple;
	bh=0nU4w252q2DLRZ1F2BgYWeOeH4dQbxVKvzzaFa9j4I0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f2DGBMSlQxP3xdjSp1HB0WZ9orgcRDmkr9hxKbtxkUlveI5tiFkV8F9hW1ESYV/wdfykFWyD71R6vAZoeVVhEGryF3SHX8C9UmTrRYD8vJVIQLdiHTVI7Yxg1KUTXOMBE/NxMM+QPFOaNTfYlUt/mqOrN5D7oQ0diLnLzPATl1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LVYKMaQ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LVYKMaQ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DCFBC19425;
	Wed, 21 Jan 2026 02:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768962007;
	bh=0nU4w252q2DLRZ1F2BgYWeOeH4dQbxVKvzzaFa9j4I0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LVYKMaQ2cHRQNeAi9n25y0Dv91VfSuogevihUsmk2HR9BuNwnDZrw9Q455PhpWHjd
	 J7lJB/eGzMzezrSzvAKD3s+heJlgmi8IW+NFcC7cj+KofCbN0IznoWFTqTrID1pBcO
	 0ez7ADlglRFbcBRqRSKO8kLdV85TQ6xZcgxRHpKN5zLRCQx9t7DF8drFDVvqgLeBU3
	 61FGgO+9OQvI/pgSxEfSZGuVXQvuWH/OMfZUH6vRuRqtIjopbkdMZ4hfjbRo5IF3VY
	 arLgb8ZMcTQekrLJsWpNivH/dME9bgT+sARcCWS/zP+Frz9iQFRIYQRfYg9OZaavC2
	 DqbGyVoBtBE4Q==
Date: Tue, 20 Jan 2026 20:20:06 -0600
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Robert Marko <robert.marko@sartura.hr>
Cc: nicolas.ferre@microchip.com, UNGLinuxDriver@microchip.com,
	gregkh@linuxfoundation.org, horatiu.vultur@microchip.com,
	andrew+netdev@lunn.ch, luka.perkov@sartura.hr,
	lars.povlsen@microchip.com, lee@kernel.org, kuba@kernel.org,
	linusw@kernel.org, richardcochran@gmail.com,
	Steen.Hegelund@microchip.com, richard.genoud@bootlin.com,
	kavyasree.kotagiri@microchip.com, davem@davemloft.net,
	krzk+dt@kernel.org, linux-spi@vger.kernel.org,
	daniel.machon@microchip.com, linux-kernel@vger.kernel.org,
	edumazet@google.com, linux-crypto@vger.kernel.org,
	conor+dt@kernel.org, linux-gpio@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, pabeni@redhat.com,
	tudor.ambarus@linaro.org, claudiu.beznea@tuxon.dev,
	herbert@gondor.apana.org.au, alexandre.belloni@bootlin.com,
	netdev@vger.kernel.org, devicetree@vger.kernel.org,
	olivia@selenic.com, radu_nicolae.pirea@upb.ro,
	linux-serial@vger.kernel.org, Ryan.Wanner@microchip.com
Subject: Re: [PATCH v5 10/11] dt-bindings: net: sparx5: do not require phys
 when RGMII is used
Message-ID: <176896200632.1779741.2061551364132854431.robh@kernel.org>
References: <20260115114021.111324-1-robert.marko@sartura.hr>
 <20260115114021.111324-11-robert.marko@sartura.hr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115114021.111324-11-robert.marko@sartura.hr>


On Thu, 15 Jan 2026 12:37:35 +0100, Robert Marko wrote:
> LAN969x has 2 dedicated RGMII ports, so regular SERDES lanes are not used
> for RGMII.
> 
> So, lets not require phys to be defined when any of the rgmii phy-modes are
> set.
> 
> Signed-off-by: Robert Marko <robert.marko@sartura.hr>
> ---
>  .../bindings/net/microchip,sparx5-switch.yaml     | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 

Reviewed-by: Rob Herring (Arm) <robh@kernel.org>

