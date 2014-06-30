From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH v1 1/3] ima: use ahash API for file hash calculation
Date: Mon, 30 Jun 2014 11:53:57 -0400
Message-ID: <1404143637.18987.22.camel@dhcp-9-2-203-236.watson.ibm.com>
References: <cover.1403191191.git.d.kasatkin@samsung.com>
	 <7b884b2597badabadf50ebf9120fe76754e1516c.1403191191.git.d.kasatkin@samsung.com>
	 <1403783690.2017.58.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <53B17AFC.80001@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ima-devel@lists.sourceforge.net,
	linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	dmitry.kasatkin@gmail.com
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <53B17AFC.80001@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, 2014-06-30 at 17:58 +0300, Dmitry Kasatkin wrote: 
> On 26/06/14 14:54, Mimi Zohar wrote:
> > On Thu, 2014-06-19 at 18:20 +0300, Dmitry Kasatkin wrote:

> >> @@ -156,7 +316,7 @@ out:
> >>  	return rc;
> >>  }
> >>
> >> -int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
> >> +static int ima_calc_file_shash(struct file *file, struct ima_digest_data *hash)
> >>  {
> >>  	struct crypto_shash *tfm;
> >>  	int rc;
> >> @@ -172,6 +332,20 @@ int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
> >>  	return rc;
> >>  }
> >>
> >> +int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
> >> +{
> >> +	loff_t i_size = i_size_read(file_inode(file));
> >> +
> >> +	/* shash is more efficient small data
> >> +	 * ahash performance depends on data size and particular HW
> >> +	 * ima_ahash_size allows to specify the best value for the system
> >> +	 */
> >> +	if (ima_ahash_size && i_size >= ima_ahash_size)
> >> +		return ima_calc_file_ahash(file, hash);
> >> +	else
> >> +		return ima_calc_file_shash(file, hash);
> >> +}
> > If calculating the file hash using ahash fails, should it fall back to
> > using shash?
> 
> If ahash fails, then it could be a HW error, which should not happen.
> IF HW fails device is broken.

I would assume it depends on the HW, if the entire device/system is
broken.

> Do you really want to fallback to shash?

Yes, in this case, there is no downside to letting it to continue
working, just slower, using the software crypto implementation.  In any
case, it shouldn't be hard coded.

Mimi
