From: "John W. Linville" <linville-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>
Subject: Re: [PATCH 4/7] net/wireless: switch lib80211_crypt_tkip from arc4
	to arc4blk
Date: Mon, 5 Apr 2010 13:13:19 -0400
Message-ID: <20100405171319.GA29596@tuxdriver.com>
References: <1270280969-11357-1-git-send-email-sebastian@breakpoint.cc> <1270280969-11357-5-git-send-email-sebastian@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Andrzej Siewior <sebastian-E0PNVn5OA6ohrxcnuTQ+TQ@public.gmane.org>
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1270280969-11357-5-git-send-email-sebastian-E0PNVn5OA6ohrxcnuTQ+TQ@public.gmane.org>
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Apr 03, 2010 at 09:49:26AM +0200, Sebastian Andrzej Siewior wrote:
> ecb(arc4) is getting replaced by arc4 which is a blkcipher by itself. The
> required selects are now pulled in by LIB80211_CRYPT_TKIP instead of
> selecting it by every driver.
> 
> Signed-off-by: Sebastian Andrzej Siewior <sebastian-E0PNVn5OA6ohrxcnuTQ+TQ@public.gmane.org>

Fine by me...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org			might be all we have.  Be ready.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
