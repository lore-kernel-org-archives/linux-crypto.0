Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83BBA29A9CA;
	Mon, 12 May 2025 20:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747083299; cv=none; b=Lun7aQOkHcc6z3uHIak+0Ym+69BXcS8chJEImUch6Bo9Bz99KK9lKlxPleoZZySQ8bLFpx7Qtq+MNuJSD6c4+YBtN9F/WnX5mX0Ma9z7youjqAL91woZ0akHYK9L0OWk/UKg9aQjeoHZBSmbSFpxa4r4WBfNjI3b0jUM/IFySsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747083299; c=relaxed/simple;
	bh=4MnOPiXLyFGyvIj0JXxrByxbb5sHvTSxERBoVbP3jrI=;
	h=Date:Content-Type:MIME-Version:From:Cc:To:In-Reply-To:References:
	 Message-Id:Subject; b=SLn3oqJcG89tumNPbMMdbvF9vquNchgy8vJGvXiDyKkBxVSfa5hZNxL1AismdWL+hHtDYIbS1/p028Uwm/NaWJb4hyMO05FjycYQ+ZUhjr4UQpQML8Uik3jT+WNUEHsPiF3WBp+UGtfdxf3RTdHYoKF5jAabWyqWyt4gr6Rc2nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L76NCfVV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L76NCfVV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0DBC4CEE9;
	Mon, 12 May 2025 20:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747083299;
	bh=4MnOPiXLyFGyvIj0JXxrByxbb5sHvTSxERBoVbP3jrI=;
	h=Date:From:Cc:To:In-Reply-To:References:Subject:From;
	b=L76NCfVVHHV1HoGV5ch5HkQi9AXePHnSPo+xJYB+NDcUqgB/ZLFx5ceZOcfev+iIk
	 FpmLkPuKeifbuSRKiVPxiL+LgcZ6VkZuvLrCkQWNV0VWwQMeS8ONMDldGzPW4sIfur
	 cy+oyufPgaaUZlDWKX34TlHoSTcZVAONqZKv+8EyxqnBhz9v8F5OIWwlhZWIbK51ew
	 lJmJYoA/bKnt0JlxCorWowwR3Cxh8C9p0iaepG+LaamucPP2cmfmx1kDaUJ1tX/rQa
	 3/mstXuPXX7X4cP0kcd/bYtuSQoM5cXtoVNIiHe/qKgd1IsjKopcaStQPFnHJtvyfd
	 wHtl58Dujkraw==
Date: Mon, 12 May 2025 15:54:57 -0500
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "Rob Herring (Arm)" <robh@kernel.org>
Cc: herbert@gondor.apana.org.au, alexandre.belloni@bootlin.com, 
 linux-crypto@vger.kernel.org, claudiu.beznea@tuxon.dev, 
 linux-kernel@vger.kernel.org, conor+dt@kernel.org, 
 linux-arm-kernel@lists.infradead.org, krzk+dt@kernel.org, 
 davem@davemloft.net, nicolas.ferre@microchip.com, 
 devicetree@vger.kernel.org, olivia@selenic.com
To: Ryan.Wanner@microchip.com
In-Reply-To: <5c87dd0c60e3ab295bf084cabb59199d5cb4d93b.1747077616.git.Ryan.Wanner@microchip.com>
References: <cover.1747077616.git.Ryan.Wanner@microchip.com>
 <5c87dd0c60e3ab295bf084cabb59199d5cb4d93b.1747077616.git.Ryan.Wanner@microchip.com>
Message-Id: <174708329386.4035852.2868529061240392113.robh@kernel.org>
Subject: Re: [PATCH 2/9] dt-bindings: crypto: add sama7d65 in Atmel SHA


On Mon, 12 May 2025 12:27:28 -0700, Ryan.Wanner@microchip.com wrote:
> From: Ryan Wanner <Ryan.Wanner@microchip.com>
> 
> Add DT bindings for SAMA7D65 SoC Atmel SHA.
> 
> Signed-off-by: Ryan Wanner <Ryan.Wanner@microchip.com>
> ---
>  .../devicetree/bindings/crypto/atmel,at91sam9g46-sha.yaml     | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 

My bot found errors running 'make dt_binding_check' on your patch:

yamllint warnings/errors:
./Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-sha.yaml:19:13: [warning] wrong indentation: expected 14 but found 12 (indentation)

dtschema/dtc warnings/errors:

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/5c87dd0c60e3ab295bf084cabb59199d5cb4d93b.1747077616.git.Ryan.Wanner@microchip.com

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.

