From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 01/11] Added macro to check for AVX2 feature.
Date: Fri, 22 Mar 2013 17:55:38 -0700
Message-ID: <7243684e-3017-4519-8758-651618da609f@email.android.com>
References: <cover.1363961999.git.tim.c.chen@linux.intel.com> <1363987742.8972.55.camel@schen9-DESK> <09e94963-5146-4c1b-ab76-64ac73d660ab@email.android.com> <1363998796.8972.69.camel@schen9-DESK>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S.Miller" <davem@davemloft.net>,
	Kirk Yap <kirk.s.yap@intel.com>,
	David Cote <david.m.cote@intel.com>,
	James Guilford <james.guilford@intel.com>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1363998796.8972.69.camel@schen9-DESK>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Just syntactic overhead.  We should probably discuss it among ourselves first though.

Tim Chen <tim.c.chen@linux.intel.com> wrote:

>On Fri, 2013-03-22 at 17:21 -0700, H. Peter Anvin wrote:
>> I really, really hate these macros... Not sure they are worth the
>extra noise.
>> 
>
>I can do without the macro and I'll remove it.
>
>Wonder the reason that such macro should be avoided?
>
>Tim

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
