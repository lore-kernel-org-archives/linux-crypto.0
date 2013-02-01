From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH 2/2] mpilib: use DIV_ROUND_UP and remove unused macros
Date: Fri, 1 Feb 2013 16:31:58 +1100 (EST)
Message-ID: <alpine.LRH.2.02.1302011631330.9167@tundra.namei.org>
References: <cover.1359538137.git.dmitry.kasatkin@intel.com> <ecbfc41bbf0a3d78e5522f1a37d090803d8f383f.1359538137.git.dmitry.kasatkin@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <ecbfc41bbf0a3d78e5522f1a37d090803d8f383f.1359538137.git.dmitry.kasatkin@intel.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, 30 Jan 2013, Dmitry Kasatkin wrote:

> From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> Remove MIN, MAX and ABS macros that are duplicates kernel's native
> implementation.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Applied.

As maintainer, you should have added your signed-off-by.


-- 
James Morris
<jmorris@namei.org>
