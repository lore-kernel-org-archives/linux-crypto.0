From: Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH 1/7] A couple of generated files
Date: Sat, 7 Nov 2015 17:01:04 +0000
Message-ID: <20151107170104.GB29227@io.lakedaemon.net>
References: <1446906642-19372-1-git-send-email-sandyinchina@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts\\'o" <tytso@mit.edu>,
	"H. Peter Anvin" <hpa@zytor.com>, John Denker <jsd@av8n.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Sandy Harris <sandyinchina@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from outbound1a.ore.mailhop.org ([54.213.22.21]:51377 "EHLO
	outbound1a.ore.mailhop.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753528AbbKGRBH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 7 Nov 2015 12:01:07 -0500
Content-Disposition: inline
In-Reply-To: <1446906642-19372-1-git-send-email-sandyinchina@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Nov 07, 2015 at 09:30:36AM -0500, Sandy Harris wrote:
> Signed-off-by: Sandy Harris <sandyinchina@gmail.com>
> ---
>  .gitignore | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/.gitignore b/.gitignore
> index fd3a355..dd80bfd 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -112,3 +112,6 @@ all.config
>  
>  # Kdevelop4
>  *.kdev4
> +
> +certs/x509_certificate_list
> +scripts/gen_random

Is there a .gitignore file in scripts/ ?

thx,

Jason.
