From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [crypto / sparc64] cryptomgr_test OOPS
Date: Wed, 4 May 2016 13:02:45 -0700
Message-ID: <06c0b4f8-becf-25f3-109a-e1500f11626a@intel.com>
References: <CADxRZqyMwme53etMrnx3xkpGsR6-W88RHLA3nh0GCGAzcz5=Fw@mail.gmail.com>
 <20160503.123301.298039059390449291.davem@davemloft.net>
 <CADxRZqzynaTAD+vcJwW2ueGnQyy=tQAJq2TvTT-_pZG26=_ZLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, sparclinux@vger.kernel.org
To: Anatoly Pugachev <matorola@gmail.com>,
	David Miller <davem@davemloft.net>
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <CADxRZqzynaTAD+vcJwW2ueGnQyy=tQAJq2TvTT-_pZG26=_ZLQ@mail.gmail.com>
Sender: sparclinux-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Anatoly,
On 05/04/2016 12:10 PM, Anatoly Pugachev wrote:
> we're using 4.5.2 debian kernel here without this problem. I'm not
> sure I would be able to bisect, never did it before, but I could
> try...

On 4.5.2 could you try "modprobe rsa"

-- 
TS
