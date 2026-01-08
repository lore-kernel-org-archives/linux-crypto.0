Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA083B9608;
	Thu,  8 Jan 2026 12:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767876027; cv=none; b=WmAgoenqwx9ymiYMsOgkAx0WZ5TQIQNNzsZBmijs4SFFjrFfZIsA3zu2t9h1+CrnKIxz1iLEe4toL8vdK/3Z0nGZXBDeSWUiWMULW06unouET9nC5ivCEOj/0f+dZohml0czk+BhzM4ZdKWJJH5is00GvfuW1O8R7x4Di0xa/zY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767876027; c=relaxed/simple;
	bh=g8rW71nJKgp3ELmmfnnyuEMXLvCZWj1pOr+SOf92ZPc=;
	h=Date:Content-Type:MIME-Version:From:Cc:To:In-Reply-To:References:
	 Message-Id:Subject; b=UyzHV0KHlAVjwO29/G7Pz+EYbJCQdw46kR88xistx5xjBb2svvJmwLY58uj7Le7XsQVSkl5IzxBi9N8n4yM5dJs44c8QzH2t5nYpVvXMDe3ibHhr/vaUYKrc7B+DFKrMCEIfuU57AhefF7JL4z5LeWw+3kMJa8IUfjPDKtWDfow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hcn62jzy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hcn62jzy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55FE8C19421;
	Thu,  8 Jan 2026 12:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767876026;
	bh=g8rW71nJKgp3ELmmfnnyuEMXLvCZWj1pOr+SOf92ZPc=;
	h=Date:From:Cc:To:In-Reply-To:References:Subject:From;
	b=Hcn62jzyajIv8HuVtK5cuHKrKkmRX+9TueZ6Zzaj/42oTxVwR/kO0Yt6AdPC8fHx1
	 4JpNYRXT8Y8SCVGq4oadCZryu51+7wr4PCgX9DBMB9j+V6DVbgwaEZfd7siscVJTvA
	 Bo2Ys4eP//eHIQoyazz9eBi68OiGKlSNogy44CAGdfNb+Ktm7amLfSnE05tnKiby0l
	 vdUdXk2vC7mjIiCsu2Te2Ng2GwKH0Ap6gZV6oL/QUR9GY5EWObUh6wHxesRC7SX35y
	 efOyz7yM44k0iaD5GHvi3zNt6vpMmsNMs48dfy+KsVQf28jgOEEZ1TCwZy0eBII+WN
	 qmWuUW5QGZR4A==
Date: Thu, 08 Jan 2026 06:40:25 -0600
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "Rob Herring (Arm)" <robh@kernel.org>
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
 davem@davemloft.net, krzk+dt@kernel.org, linux-kernel@vger.kernel.org, 
 herbert@gondor.apana.org.au, linux-arm-kernel@lists.infradead.org, 
 linux-mediatek@lists.infradead.org, kernel@collabora.com, 
 conor+dt@kernel.org, sebastian.hesselbarth@gmail.com, atenart@kernel.org, 
 andrew@lunn.ch, matthias.bgg@gmail.com, gregory.clement@bootlin.com
To: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
In-Reply-To: <20260108110223.20008-3-angelogioacchino.delregno@collabora.com>
References: <20260108110223.20008-1-angelogioacchino.delregno@collabora.com>
 <20260108110223.20008-3-angelogioacchino.delregno@collabora.com>
Message-Id: <176787602550.3796160.16323970790591047960.robh@kernel.org>
Subject: Re: [PATCH 2/4] dt-bindings: crypto: inside-secure,safexcel: Add
 SoC compatibles


On Thu, 08 Jan 2026 12:02:21 +0100, AngeloGioacchino Del Regno wrote:
> Add SoC specific compatibles for the SafeXcel crypto engine,
> including one for the EIP197B used by Marvell Armada CP110 and
> and two for the EIP97IES used by Marvell Armada 3700 and by
> MediaTek MT7986.
> 
> Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
> ---
>  .../bindings/crypto/inside-secure,safexcel.yaml           | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 

My bot found errors running 'make dt_binding_check' on your patch:

yamllint warnings/errors:
./Documentation/devicetree/bindings/crypto/inside-secure,safexcel.yaml:16:9: [warning] wrong indentation: expected 10 but found 8 (indentation)
./Documentation/devicetree/bindings/crypto/inside-secure,safexcel.yaml:19:9: [warning] wrong indentation: expected 10 but found 8 (indentation)
./Documentation/devicetree/bindings/crypto/inside-secure,safexcel.yaml:20:11: [warning] wrong indentation: expected 12 but found 10 (indentation)

dtschema/dtc warnings/errors:

doc reference errors (make refcheckdocs):

See https://patchwork.kernel.org/project/devicetree/patch/20260108110223.20008-3-angelogioacchino.delregno@collabora.com

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.

