From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] /dev/random fixes for 4.17-rc3
Date: Thu, 26 Apr 2018 02:37:31 -0400
Message-ID: <20180426063731.GA8280@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The following changes since commit d848e5f8e1ebdb227d045db55fe4f825e82965fa:

  random: add new ioctl RNDRESEEDCRNG (2018-04-14 11:59:31 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/random.git tags/random_for_linus_stable

for you to fetch changes up to 4e00b339e264802851aff8e73cde7d24b57b18ce:

  random: rate limit unseeded randomness warnings (2018-04-25 02:41:39 -0400)

----------------------------------------------------------------
Fix a regression on NUMA kernels and suppress excess unseeded entropy
pool warnings.

----------------------------------------------------------------
Theodore Ts'o (2):
      random: fix possible sleeping allocation from irq context
      random: rate limit unseeded randomness warnings

 drivers/char/random.c | 48 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 42 insertions(+), 6 deletions(-)
