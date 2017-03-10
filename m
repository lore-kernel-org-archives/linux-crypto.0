From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] crypto: Add ECB dependency for XTS mode
Date: Fri, 10 Mar 2017 08:36:55 +0100
Message-ID: <20170310073655.GA8956@kroah.com>
References: <20170221231717.GA7186@nicolas-laptop>
 <20170223073826.19066-1-gmazyland@gmail.com>
 <02f80ce3-4c85-78ea-7b15-4467a2ae5be4@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org, linux-crypto@vger.kernel.org,
        herbert@gondor.apana.org.au
To: Milan Broz <gmazyland@gmail.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <02f80ce3-4c85-78ea-7b15-4467a2ae5be4@gmail.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Mar 03, 2017 at 07:25:21AM +0100, Milan Broz wrote:
> Patch below should be backported to 4.10 stable
> (only 4.10, older kernels are ok).
> We have reports some systems fail to boot from LUKS now
> (missing ecb module in initramdisk) ...
> 
> Upstream commit is 12cb3a1c4184f891d965d1f39f8cfcc9ef617647

Now queued up, thanks.

greg k-h
