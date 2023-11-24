Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B59FF170D;
	Fri, 24 Nov 2023 02:16:38 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1r6TEb-00369z-DJ; Fri, 24 Nov 2023 18:16:30 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 24 Nov 2023 18:16:37 +0800
Date: Fri, 24 Nov 2023 18:16:37 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Antoine Tenart <atenart@kernel.org>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	=?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [PATCH V2] dt-bindings: crypto: convert Inside Secure SafeXcel
 to the json-schema
Message-ID: <ZWB4BX/qDR7czEeL@gondor.apana.org.au>
References: <20231116180641.29420-1-zajec5@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231116180641.29420-1-zajec5@gmail.com>

On Thu, Nov 16, 2023 at 07:06:41PM +0100, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> This helps validating DTS files.
> 
> Cc: Antoine Tenart <atenart@kernel.org>
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
> V2: Rename file to inside-secure,safexcel.yaml
>     Drop minItems from interrupts
>     Move additionalProperties down
>     Improve condition in allOf
> 
> Sorry for those issues in V1. I hope I didn't miss anything this time.
> 
>  .../crypto/inside-secure,safexcel.yaml        | 86 +++++++++++++++++++
>  .../crypto/inside-secure-safexcel.txt         | 40 ---------
>  2 files changed, 86 insertions(+), 40 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/crypto/inside-secure,safexcel.yaml
>  delete mode 100644 Documentation/devicetree/bindings/crypto/inside-secure-safexcel.txt

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
