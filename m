From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCHv3][trivial] crypto: tcrypt - reduce stack size
Date: Wed, 25 Feb 2009 10:32:31 -0500
Message-ID: <20090225153231.GA16691@hmsreliant.think-freely.org>
References: <49A54C23.8090209@suse.de> <49A5549F.4070304@suse.de> <49A55B5A.70705@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux kernel <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, akpm@linux-foundation.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>, lho@amcc.com,
	kaber@trash.net, darrenrjenkins@gmail.com,
	Frank Seidel <frank@f-seidel.de>
To: Frank Seidel <fseidel@suse.de>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1762889AbZBYPdD@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <49A55B5A.70705@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Feb 25, 2009 at 03:53:14PM +0100, Frank Seidel wrote:
> From: Frank Seidel <frank@f-seidel.de>
> 
> Applying kernel janitors todos (printk calls need KERN_*
> constants on linebeginnings, reduce stack footprint where
> possible) to tcrypts test_hash_speed (where stacks
> memory footprint was very high (on i386 1184 bytes to
> 160 now).
> 
> Signed-off-by: Frank Seidel <frank@f-seidel.de>
Looks good, thanks Frank
Acked-by: Neil Horman <nhorman@tuxdriver.com>
