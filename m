From: "Thomas D." <whissi@whissi.de>
Subject: Re: Broken userspace crypto in linux-4.1.18
Date: Sat, 20 Feb 2016 15:33:13 +0100
Message-ID: <56C87929.8040304@whissi.de>
References: <56C47DF9.6030704@whissi.de> <20160217233353.GC31125@1wt.eu>
 <56C50725.6080408@whissi.de> <4580306.arupsYiYbb@positron.chronox.de>
 <56C591E7.5080808@suse.cz> <56C5A66E.5010905@whissi.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Willy Tarreau <w@1wt.eu>, Sasha Levin <sasha.levin@oracle.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"dvyukov@google.com" <dvyukov@google.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Greg KH <gregkh@linuxfoundation.org>
To: Jiri Slaby <jslaby@suse.cz>, Stephan Mueller <smueller@chronox.de>,
	"gmazyland@gmail.com" <gmazyland@gmail.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <56C5A66E.5010905@whissi.de>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

FYI: v3.10.97, v3.14.61 and 3.18.27 are also affected.

v4.3.6 works. Looks like the patch set is only compatible with >=linux-4.3.

v3.12.54 works because it doesn't contain the patch in question.


-Thomas
