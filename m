From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Date: Thu, 17 Jul 2014 12:31:45 -0700
Message-ID: <20140717193145.GA4703@kroah.com>
References: <1405588695-12014-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-abi@vger.kernel.org,
	linux-crypto@vger.kernel.org, beck@openbsd.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1405588695-12014-1-git-send-email-tytso@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jul 17, 2014 at 05:18:15AM -0400, Theodore Ts'o wrote:

Minor nit:

> @@ -469,6 +471,8 @@ static struct entropy_store nonblocking_pool = {
>  					push_to_pool),
>  };
>  
> +DECLARE_COMPLETION(urandom_initialized);
> +

static DECLARE_COMPLETION(urandom_initialized);

instead?

thanks,

greg k-h
