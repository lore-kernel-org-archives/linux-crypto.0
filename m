From: Eric Wheeler <linux-crypto@lists.ewheeler.net>
Subject: Re: crypto regression in 4.1.18: Check that kernel supports
 aes-cbc-essiv:sha256 cipher
Date: Thu, 10 Mar 2016 05:55:52 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1603100555070.13488@mail.ewheeler.net>
References: <alpine.LRH.2.11.1603010129330.3635@mail.ewheeler.net> <20160301025853.GB17542@kroah.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "Wang, Rui Y" <rui.y.wang@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jean Delvare <jdelvare@suse.de>, linux-crypto@vger.kernel.org,
	stable@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20160301025853.GB17542@kroah.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, 1 Mar 2016, Greg KH wrote:
> On Tue, Mar 01, 2016 at 01:32:05AM +0000, Eric Wheeler wrote:
> > Hello all,
> > 
> > We updated from 4.1.17 to 4.1.18 (same .config) and now get the following 
> > error when trying to open a LUKS volume.  We've reverted to 4.1.17 and it 
> > still works, so except that I'm not sure which commit caused the problem, 
> > it is likely one of the recent commits:
> > 
> > When we `cryptsetup luksOpen` the volume we get this:
> > 
> >   Check that kernel supports aes-cbc-essiv:sha256 cipher (check syslog for more info).  
> > 
> > Note that I do not see any dm-crypto commits so I don't think its a 
> > dm-crypto issue. 
> > 
> > I'm happy to test, but can someone who knows the crypto stack suggest 
> > which of these patches I should focus on for testing? These are the 
> > commits in 4.1.18 that could be relevant:
> 
> There are some pending crypto backports to resolve this that hopefully
> will show up in the next release, whenever Sasha gets to it.

Thanks Greg.

Confirmed fixed in 4.1.19.

-Eric

> 
> thanks,
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
