From: Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH 1/7] A couple of generated files
Date: Sat, 7 Nov 2015 16:53:43 +0000
Message-ID: <20151107165343.GA29133@io.lakedaemon.net>
References: <1446906642-19372-1-git-send-email-sandyinchina@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts\\'o" <tytso@mit.edu>,
	"H. Peter Anvin" <hpa@zytor.com>, John Denker <jsd@av8n.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Sandy Harris <sandyinchina@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1446906642-19372-1-git-send-email-sandyinchina@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hey Sandy,

I know we talked  about this series offlist, but we need to fill in
folks who are seeing it for the first time.  Usually, this is done with
a coverletter (--coverletter for git format-patch).  No need to resend
before receiving feedback, but would you mind replying with a
description of the problem you're attempting to solve and how the series
solves it?

thx,

Jason.

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
> -- 
> 2.5.0
> 
