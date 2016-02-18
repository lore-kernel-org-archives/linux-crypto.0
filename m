From: "Thomas D." <whissi@whissi.de>
Subject: Re: Broken userspace crypto in linux-4.1.18
Date: Thu, 18 Feb 2016 12:09:34 +0100
Message-ID: <56C5A66E.5010905@whissi.de>
References: <56C47DF9.6030704@whissi.de> <20160217233353.GC31125@1wt.eu>
 <56C50725.6080408@whissi.de> <4580306.arupsYiYbb@positron.chronox.de>
 <56C591E7.5080808@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Willy Tarreau <w@1wt.eu>, Sasha Levin <sasha.levin@oracle.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"dvyukov@google.com" <dvyukov@google.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Jiri Slaby <jslaby@suse.cz>, Stephan Mueller <smueller@chronox.de>,
	gmazyland@gmail.com
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <56C591E7.5080808@suse.cz>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

Jiri Slaby wrote:
>> That breakage was expected and forcasted by Milan Broz a couple of days ago on 
>> this mailing list.
>
> Could you be more specific? What is "this mailing list"? stable or
> crypto? I cannot see anything from Milan on this mailing list aka stable.

Cannot speak for Stephan but I guess he means the "[PATCH v2] crypto:
algif_skcipher - Require setkey before accept(2)" thread on the crypto ml:

http://www.spinics.net/lists/linux-crypto/msg17931.html

http://www.spinics.net/lists/linux-crypto/msg17936.html


PS: In 4.4.2 it looks like the same commit breaking 4.1.8 was added
however 4.4.2 works for me.


-Thomas
